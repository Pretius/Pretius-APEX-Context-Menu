create or replace package body "PRETIUS_APEX_CONTEXT_MENU" is

  g_app_id  constant number default v('APP_ID');
  g_page_id constant number default v('APP_PAGE_ID');
  g_session constant number default v('SESSION');

  g_debug_text constant varchar2(4000) default v('DEBUG');
  g_debug      constant boolean  default case when g_debug_text in ('YES', 'LEVEL6', 'LEVEL9') then true else false end;

  g_dynamic_action apex_plugin.t_dynamic_action;
  g_plugin         apex_plugin.t_plugin;


  /*
    returns boolean result of pl/sql expression
  */  
  function getPlsqlExpressionResult(
    pi_expression in APEX_APPLICATION_LIST_ENTRIES.CONDITION_EXPRESSION1%TYPE
  ) return boolean
  is
    v_expression APEX_APPLICATION_LIST_ENTRIES.CONDITION_EXPRESSION1%TYPE;
    v_func_block varchar2(32000);
    v_result varchar2(1);
  BEGIN
    v_expression := apex_plugin_util.replace_substitutions (
      p_value  => pi_expression,
      p_escape => true
    );  

    v_func_block := '
      begin 
        if '||v_expression||' then 
          return 1; 
        else 
         return 0; 
        end if;

      end;
    ';
   
    v_result := APEX_PLUGIN_UTIL.GET_PLSQL_FUNCTION_RESULT( v_func_block );

    if v_result = '1' then
      return true;
    else
      return false;
    end if;

  EXCEPTION
    WHEN OTHERS then
      return false;
  end getPlsqlExpressionResult;

  /*
  */
  function getFuncBooleanResult(
    pi_code in APEX_APPLICATION_LIST_ENTRIES.CONDITION_EXPRESSION1%TYPE
  ) return boolean
  is
    v_func_block varchar2(32000);
    v_result varchar2(1);
    v_code varchar2(32000);
  BEGIN
    
    v_code := upper(pi_code);

    --v_code := perform_binds( WWV_FLOW.DO_SUBSTITUTIONS( v_code ) );
    v_code := apex_plugin_util.replace_substitutions (
      p_value  => v_code,
      p_escape => true
    );  
    

    if instr(v_code, 'DECLARE') > 0 then
      v_code := replace(v_code, 'DECLARE', 'function test return boolean is');
      
    elsif instr(v_code, 'BEGIN') > 0 then
      
      v_code := replace(v_code, 'BEGIN', 'function test return boolean is begin');
    else
      v_code := 'function test return boolean is begin '||v_code||' end;';
    end if;

    v_func_block := '
      declare
        v_result boolean;
        '||v_code||'
      begin
        v_result := test();

        if v_result then
          :out := 1;
        else
          :out := 0;
        end if;
      end; 
    ';

    execute immediate v_func_block using out v_result;

    if v_result = 1 then
      return true;
    else
      return false;
    end if;

  end getFuncBooleanResult;

  /*
  */
  function selectCountFromQuery(
    pi_query in APEX_APPLICATION_LIST_ENTRIES.CONDITION_EXPRESSION1%TYPE
  ) return number
  is
    v_query varchar2(32000);
    v_count number :=0;
  BEGIN

    v_query := apex_plugin_util.replace_substitutions (
      p_value  => pi_query,
      p_escape => true
    );  

    v_query := 'select count(1) from ('|| v_query ||')';

    execute immediate v_query into v_count;

    return v_count;

  end selectCountFromQuery;

  /*
  */
  function getEntryConditionResult(
    pi_condition_type in APEX_APPLICATION_LIST_ENTRIES.CONDITION_TYPE_CODE%TYPE,
    pi_expression     in APEX_APPLICATION_LIST_ENTRIES.CONDITION_EXPRESSION1%TYPE
  ) return boolean is 
  begin

    if pi_condition_type in ('PLSQL_EXPRESION', 'PLSQL_EXPRESSION') then
      return getPlsqlExpressionResult( pi_expression );
    elsif pi_condition_type = 'FUNC_BODY_RETURNING_BOOLEAN' then
      return getFuncBooleanResult( pi_expression );
    elsif pi_condition_type = 'EXISTS' then
      return selectCountFromQuery( pi_expression ) > 0;
    elsif pi_condition_type = 'NOT_EXISTS' then
      return selectCountFromQuery( pi_expression ) < 1;   
    elsif pi_condition_type = 'NEVER' then
      return false;
    elsif pi_condition_type is null then
      return true;
    else
      return false;
    end if;


  end getEntryConditionResult;

  /*
  */
  procedure getEntryJson(
    pi_entry in APEX_APPLICATION_LIST_ENTRIES%ROWTYPE
  ) as
    v_url varchar2(4000);
    v_condition_result boolean;
    v_as_result boolean;
    v_sublist_cnt number;
  begin
    
    select 
      count(1) 
    into
      v_sublist_cnt
    from 
      APEX_APPLICATION_LIST_ENTRIES 
    where 
      application_id = g_app_id
      and LIST_NAME = pi_entry.LIST_NAME
      and LIST_ENTRY_PARENT_ID = pi_entry.LIST_ENTRY_ID
    order by
      DISPLAY_SEQUENCE asc
    ;

    v_url := pi_entry.ENTRY_TARGET;

    v_url := replace(v_url, chr(38)||'APP_ID'||chr(46), g_app_id);
    v_url := replace(v_url, chr(38)||'SESSION'||chr(46), g_session);
    v_url := replace(v_url, chr(38)||'DEBUG'||chr(46), g_debug_text);


    v_url := APEX_UTIL.PREPARE_URL (
      p_url                => v_url
      --p_url_charset        IN VARCHAR2 default null,
      --p_checksum_type      IN VARCHAR2 default null,
      --p_triggering_element IN VARCHAR2 default 'this'
    );

    

    apex_json.write('SEQ',                        pi_entry.DISPLAY_SEQUENCE,          true);
    apex_json.write('ENTRY_IMAGE',                pi_entry.ENTRY_IMAGE,               true);
    apex_json.write('ENTRY_TARGET',               v_url,                              true);
    apex_json.write('ENTRY_TEXT',                 pi_entry.ENTRY_TEXT,                true);
    apex_json.write('ENTRY_IMAGE_ATTRIBUTES',     pi_entry.ENTRY_IMAGE_ATTRIBUTES,    true);
    apex_json.write('ENTRY_IMAGE_ALT_ATTRIBUTE',  pi_entry.ENTRY_IMAGE_ALT_ATTRIBUTE, true);
    -- reserved by menu template - not described by API
    -- data id
    apex_json.write('ENTRY_ATTRIBUTE_01',         pi_entry.ENTRY_ATTRIBUTE_01,        true);
    -- reserved by menu template and menu api
    -- disabled
    apex_json.write('ENTRY_ATTRIBUTE_02',         pi_entry.ENTRY_ATTRIBUTE_02,        true);
    -- reserved by menu template and menu api
    -- hidden
    apex_json.write('ENTRY_ATTRIBUTE_03',         pi_entry.ENTRY_ATTRIBUTE_03,        true);
    -- reserved by menu template and menu api
    -- title but not implemented?
    apex_json.write('ENTRY_ATTRIBUTE_04',         pi_entry.ENTRY_ATTRIBUTE_04,        true);
    -- reserved by menu template and menu api
    -- shortcut? but not implemented?
    apex_json.write('ENTRY_ATTRIBUTE_05',         pi_entry.ENTRY_ATTRIBUTE_05,        true);
    apex_json.write('ENTRY_ATTRIBUTE_06',         pi_entry.ENTRY_ATTRIBUTE_06,        true);
    apex_json.write('ENTRY_ATTRIBUTE_07',         pi_entry.ENTRY_ATTRIBUTE_07,        true);
    apex_json.write('ENTRY_ATTRIBUTE_08',         pi_entry.ENTRY_ATTRIBUTE_08,        true);
    apex_json.write('ENTRY_ATTRIBUTE_09',         pi_entry.ENTRY_ATTRIBUTE_09,        true);
    apex_json.write('ENTRY_ATTRIBUTE_10',         pi_entry.ENTRY_ATTRIBUTE_10,        true);

    if v_sublist_cnt > 0 then

      apex_json.open_array('items');

      for list in (
        select 
          * 
        from 
          APEX_APPLICATION_LIST_ENTRIES 
        where 
          application_id = g_app_id 
          and LIST_NAME = pi_entry.LIST_NAME
          and LIST_ENTRY_PARENT_ID = pi_entry.LIST_ENTRY_ID
        order by
          DISPLAY_SEQUENCE asc
      ) loop

        --check authorization scheme
        v_as_result := APEX_AUTHORIZATION.IS_AUTHORIZED(list.AUTHORIZATION_SCHEME);

        if ( not v_as_result ) then
          continue;
        end if;

        --check entry condition
        v_condition_result := getEntryConditionResult(list.CONDITION_TYPE_CODE, list.CONDITION_EXPRESSION1);

        if ( not v_condition_result ) then
          continue;
        end if;

        apex_json.open_object;

        getEntryJson( list );

        apex_json.close_object;

      end loop;
      
      apex_json.close_array;
    end if;

    
  end getEntryJson;

  procedure getListTypeAndQuery(
    pi_list_name  in  APEX_APPLICATION_LISTS.LIST_NAME%type,
    pi_list_type  out APEX_APPLICATION_LISTS.LIST_TYPE_CODE%type,
    pi_list_query out APEX_APPLICATION_LISTS.LIST_QUERY%type
  ) as 
  begin
    select 
      LIST_TYPE_CODE,
      LIST_QUERY
    into
      pi_list_type,
      pi_list_query
    from 
      APEX_APPLICATION_LISTS 
    where 
      application_id = g_app_id
      and list_name = pi_list_name;
  exception
    when others then
      APEX_ERROR.ADD_ERROR (
        p_message          => 'Pretius APEX Context Menu',
        p_additional_info  => 'List name <strong>'||pi_list_name||'</strong> provided in the plugin configuration not found. Make sure provided value maps to existing list defined in <strong>Shared Components > Lists</strong>',
        p_display_location => apex_error.c_on_error_page
      );

  end;

  /*
  */
  function getDynamicActionDefinition return varchar2 as 
    v_refcursor_da sys_refcursor;
    v_refcursor_action sys_refcursor;

    v_da APEX_APPLICATION_PAGE_DA%rowtype;
  begin

    select 
      aapd.*
    into
      v_da
    from 
      APEX_APPLICATION_PAGE_DA_ACTS aapda
    join
      APEX_APPLICATION_PAGE_DA aapd
    on
      aapd.DYNAMIC_ACTION_ID = aapda.DYNAMIC_ACTION_ID
    where 
      aapda.application_id = g_app_id
      and aapda.action_id  = g_dynamic_action.id;

    apex_json.initialize_clob_output;

    apex_json.open_object;

    apex_json.write( 'WHEN_ELEMENT'            , v_da.WHEN_ELEMENT            , true );
    apex_json.write( 'WHEN_EVENT_CUSTOM_NAME'  , v_da.WHEN_EVENT_CUSTOM_NAME  , true );
    apex_json.write( 'WHEN_EVENT_INTERNAL_NAME', v_da.WHEN_EVENT_INTERNAL_NAME, true );
    apex_json.write( 'WHEN_EVENT_NAME'         , v_da.WHEN_EVENT_NAME         , true );
    apex_json.write( 'WHEN_EVENT_SCOPE'        , v_da.WHEN_EVENT_SCOPE        , true );
    apex_json.write( 'WHEN_SELECTION_TYPE'     , v_da.WHEN_SELECTION_TYPE     , true );
    apex_json.write( 'WHEN_SELECTION_TYPE_CODE', v_da.WHEN_SELECTION_TYPE_CODE, true );
    apex_json.write( 'DYNAMIC_ACTION_NAME'     , v_da.DYNAMIC_ACTION_NAME, true );
    

    

    apex_json.close_object;

    return apex_json.get_clob_output;

  end getDynamicActionDefinition;


  /*
  */

  /*
  */
  function render (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin 
  ) return apex_plugin.t_dynamic_action_render_result 
  as
    v_result apex_plugin.t_dynamic_action_render_result;
    v_json varchar2(32000);

    

    v_attr_list_name        APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_01%TYPE := p_dynamic_action.attribute_01;
    v_attr_settings_chbx    APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_02%TYPE := NVL(p_dynamic_action.attribute_02, 'null');
    v_attr_override_entries APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_03%TYPE := p_dynamic_action.attribute_03;
    v_attr_extra_entries    APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_04%TYPE := p_dynamic_action.attribute_04;
    --ATTRIBUTE_05 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_05%TYPE := p_dynamic_action.attribute_05; 
    --ATTRIBUTE_06 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_06%TYPE := p_dynamic_action.attribute_06;
    --ATTRIBUTE_07 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_07%TYPE := p_dynamic_action.attribute_07;
    --ATTRIBUTE_08 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_08%TYPE := p_dynamic_action.attribute_08;
    --ATTRIBUTE_09 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_09%TYPE := p_dynamic_action.attribute_09;
    --ATTRIBUTE_10 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_10%TYPE := p_dynamic_action.attribute_10;
    --ATTRIBUTE_11 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_11%TYPE := p_dynamic_action.attribute_11;
    --ATTRIBUTE_12 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_12%TYPE := p_dynamic_action.attribute_12;
    --ATTRIBUTE_13 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_13%TYPE := p_dynamic_action.attribute_13;
    --ATTRIBUTE_14 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_14%TYPE := p_dynamic_action.attribute_14;
    --ATTRIBUTE_15 APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_15%TYPE := p_dynamic_action.attribute_15;

    v_list_type   APEX_APPLICATION_LISTS.LIST_TYPE%TYPE;
    v_list_query  APEX_APPLICATION_LISTS.LIST_QUERY%TYPE;

    c sys_refcursor;

    v_condition_result boolean;
    v_as_result        boolean;

    v_as_name APEX_APPLICATION_AUTHORIZATION.AUTHORIZATION_SCHEME_NAME%TYPE;
  begin

    g_dynamic_action := p_dynamic_action;
    g_plugin         := p_plugin;


    v_result.ajax_identifier     := wwv_flow_plugin.get_ajax_identifier;

    v_result.attribute_01        := v_attr_list_name;

    v_result.attribute_02        := v_attr_settings_chbx;
    v_result.attribute_03        := v_attr_override_entries;
    v_result.attribute_04        := v_attr_extra_entries;
    v_result.attribute_05        := p_dynamic_action.attribute_05;
    v_result.attribute_06        := p_dynamic_action.attribute_06;
    v_result.attribute_07        := p_dynamic_action.attribute_07;
    v_result.attribute_08        := p_dynamic_action.attribute_08;
    v_result.attribute_09        := p_dynamic_action.attribute_09;
    v_result.attribute_10        := p_dynamic_action.attribute_10;
    v_result.attribute_11        := p_dynamic_action.attribute_11;
    v_result.attribute_12        := p_dynamic_action.attribute_12;
    v_result.attribute_13        := p_dynamic_action.attribute_13;
    v_result.attribute_14        := p_dynamic_action.attribute_14;
    v_result.attribute_15        := p_dynamic_action.attribute_15;
    
    getListTypeAndQuery(
      pi_list_name  => v_attr_list_name,  
      pi_list_type  => v_list_type,
      pi_list_query => v_list_query
    );

    apex_json.initialize_clob_output;

    if v_list_type = 'STATIC' then

      apex_json.open_array;

      for list in (
        select 
          * 
        from 
          APEX_APPLICATION_LIST_ENTRIES 
        where 
          application_id = g_app_id 
          and LIST_NAME = v_attr_list_name
          and LIST_ENTRY_PARENT_ID is null
        order by
          DISPLAY_SEQUENCE asc
      ) loop

        --check authorization scheme
        if instr(list.AUTHORIZATION_SCHEME, 'Not') > 0 then
          --get proper name
          --it should always return row
          --if not then apex data is mess
          select
            AUTHORIZATION_SCHEME_NAME
          into
            v_as_name

          from
            APEX_APPLICATION_AUTHORIZATION
          where
            application_id = g_app_id
            and AUTHORIZATION_SCHEME_ID = trim(leading '!' from list.AUTHORIZATION_SCHEME_ID);

          v_as_result := not APEX_AUTHORIZATION.IS_AUTHORIZED(v_as_name);
        else
          v_as_result := APEX_AUTHORIZATION.IS_AUTHORIZED(list.AUTHORIZATION_SCHEME);
        end if;        

        if ( not v_as_result ) then
          continue;
        end if;

        --check entry condition
        v_condition_result := getEntryConditionResult(list.CONDITION_TYPE_CODE, list.CONDITION_EXPRESSION1);

        if ( not v_condition_result ) then
          continue;
        end if;

        apex_json.open_object;
        --
        getEntryJson( list );

        apex_json.close_object;

      end loop;

      apex_json.close_array();      

    else --SQL_QUERY

      if v_list_type = 'FUNCTION_RETURNING_SQL_QUERY' then
        v_list_query := APEX_PLUGIN_UTIL.GET_PLSQL_FUNCTION_RESULT(
          p_plsql_function => v_list_query
        );
      end if;

      open c for v_list_query;

      apex_json.write(c);

    end if;
    
    v_json := apex_json.get_clob_output;

    apex_json.free_output;

    v_result.javascript_function := '
      function(){
        var 
          json = {
            type: "'||v_list_type||'", 
            entries: '||v_json||',
            da: '||getDynamicActionDefinition||'
          };
        
        try{
          ($.proxy( pretius_handle_da, this, json ))().init();

        } catch( pError ) {
          var 
            da = '||getDynamicActionDefinition||',
            daName = da.DYNAMIC_ACTION_NAME;
            
          apex.debug.message( apex.debug.LOG_LEVEL.ERROR, ''Dynamic action "''+daName+''":'',  pError);
          //apex.debug.message( apex.debug.LOG_LEVEL.ERROR, daName, "json", json);
          //apex.debug.message( apex.debug.LOG_LEVEL.ERROR, daName, "this", this);
          //throw pError;
        }
        

        return void(0);
      }
    ';

    return v_result;
  end render;

end "PRETIUS_APEX_CONTEXT_MENU";
