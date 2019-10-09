prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>1680777737499838
,p_default_application_id=>1102
,p_default_owner=>'APEXCONNECT'
);
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_pretius_apex_contextmenu
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(267205648688277419)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.PRETIUS.APEX.CONTEXTMENU'
,p_display_name=>'Pretius APEX Context Menu'
,p_category=>'NAVIGATION'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#pretius.apexListMenu.js',
'#PLUGIN_FILES#pretius.handleDa.js',
'',
''))
,p_css_file_urls=>'#PLUGIN_FILES#pretius.apexListMenu.css'
,p_api_version=>2
,p_render_function=>'#OWNER#.PRETIUS_APEX_CONTEXT_MENU.render'
,p_standard_attributes=>'ITEM:BUTTON:REGION:JQUERY_SELECTOR:JAVASCRIPT_EXPRESSION:TRIGGERING_ELEMENT:EVENT_SOURCE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<strong>About plugin</strong>',
'<p>',
'  Pretius APEX Context Menu is dynamic action plugin implementing context menu based on defined APEX list.',
'</p>',
'<p>',
'  Github: <code>https://github.com/bostrowski/Pretius-APEX-Context-Menu</code>',
'</p>',
'<strong>About author</strong>',
'</p>',
'<p>',
'  Author: <code>Bartosz Ostrowski</code><br/>',
'  E-mail: <code>ostrowski.bartosz@gmail.com</code><br/>',
'  Twitter: <code>@bostrowsk1</code><br/>',
'  Website: http://www.ostrowskibartosz.pl',
'</p>',
'<strong>About Pretius</strong>',
'<p>',
'  Website: http://pretius.com',
'</p>'))
,p_version_identifier=>'1.1.0'
,p_about_url=>'https://github.com/bostrowski/Pretius-APEX-Context-Menu'
,p_files_version=>150
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(267205955301289504)
,p_plugin_id=>wwv_flow_api.id(267205648688277419)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'List name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h4>Dynamic SQL query</h4>',
'<pre>',
'select ',
'  null                  level,                 --not used',
'  ''Entry text''          label,                 --entry text displayed ',
'  ''javascript: void(0)'' target,                --href attribute value',
'  null                  is_current_list_entry, --not used',
'  ''fa-search''           image,                 --icon to be displayed',
'  null                  image_attribute,       --not used',
'  null                  image_alt_attribute,   --not used',
'  ''ENTRY_ID''            attribute1,            --used to identify entry',
'  ''true''                attribute2,            --disable flag. When "true", entry is disabled',
'  ''false''               attribute3,            --hidden flag. When "true", entry is not rendered',
'  null                  attribute4,            --title - not working',
'  null                  attribute5,            --shortcut - not working',
'  ''Accelerator''         attribute6,            --accelerator text to be displayed next to entry text',
'  null                  attribute7,            --entry type. When "seperator", entry is rendered as separator',
'  null                  attribute8,            --not used',
'  null                  attribute9,            --not used',
'  null                  attribute10            --not used',
'from ',
'  dual',
'</pre>',
'',
'<h4>Dynamic Function returing SQL query</h4>',
'<pre>',
'return ''',
'  select ',
'    null                    level,                 --not used',
'    ''''Entry text''''          label,                 --entry text displayed ',
'    ''''javascript: void(0)'''' target,                --href attribute value',
'    null                    is_current_list_entry, --not used',
'    ''''fa-search''''           image,                 --icon to be displayed',
'    null                    image_attribute,       --not used',
'    null                    image_alt_attribute,   --not used',
'    ''''ENTRY_ID''''            attribute1,            --used to identify entry',
'    ''''true''''                attribute2,            --disable flag. When "true", entry is disabled',
'    ''''false''''               attribute3,            --hidden flag. When "true", entry is not rendered',
'    null                    attribute4,            --title - not working',
'    null                    attribute5,            --shortcut - not working',
'    ''''Accelerator''''         attribute6,            --accelerator text to be displayed next to entry text',
'    null                    attribute7,            --entry type. When "seperator", entry is rendered as separator',
'    null                    attribute8,            --not used',
'    null                    attribute9,            --not used',
'    null                    attribute10            --not used',
'  from ',
'    dual',
''';  ',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  Oracle APEX <strong>list name</strong> defined in <i>Shared Components > Lists</i>. ',
'  Given list will be rendered as APEX list menu using native APEX menu API.',
'  The plugin support all types of list:',
'</p>',
'<ul>',
'  <li>static</li>',
'  <li>SQL query</li>',
'  <li>function returining SQL query</li>',
'</ul>',
'<br>',
'<p>',
'  List entries are rendered depending on result of authorization scheme. When no authorization scheme is set or authorization scheme passes list entry is rendered.',
'</p>',
'<h4>User Defined Attributes</h4>',
'<p>',
'  User defined attributes can be defined in <i>Shared Components > Lists > List entry</i>.',
'</p>',
'<dl>',
'  <dt>Attribute 1</dt>',
'  <dd>',
'    Provided text is used as <strong>id</strong> for list entry. ',
'    Value can be used to identify list entry when extending with JSON object described in <strong>Override Behaviour</strong> attribute.',
'  </dd>',
'',
'  <dt>Attribute 2</dt>',
'  <dd>',
'    When set to <strong>true</strong> then list entry is disabled.',
'  </dd>',
'',
'  <dt>Attribute 3</dt>',
'  <dd>',
'    When set to <strong>true</strong> then list entry is not rendered',
'  </dd>',
'',
'  <dt>Attribute 4</dt>',
'  <dd>',
'    Reserved by APEX navigation template to set title. Not working.',
'  </dd>',
'',
'  <dt>Attribute 5</dt>',
'  <dd>',
'    Reserved by APEX navigation template to set shortcut(?). Not working.',
'  </dd>',
'',
'  <dt>Attribute 6</dt>',
'  <dd>Provided text is used as <strong>accelerator text</strong> displayed right to entry label.</dd>',
'',
'  <dt>Attribute 7</dt>',
'  <dd>When set to <strong>separator</strong> then display as horizontal separator</dd>',
'',
'  <dt>Attribute 8</dt>',
'  <dd>Not used.</dd>',
'',
'  <dt>Attribute 9</dt>',
'  <dd>Not used.</dd>',
'',
'  <dt>Attribute 10</dt>',
'  <dd>Not used.</dd>',
'',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(223322603767701262)
,p_plugin_id=>wwv_flow_api.id(267205648688277419)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Settings'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'SEP'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  This attribute allows to do advanced configuration of the plugin. ',
'  Attributes <strong>Override Behaviour</strong> and <strong>Add Extra Entries</strong> requires JavaScript knowledge.',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(223325184799706033)
,p_plugin_attribute_id=>wwv_flow_api.id(223322603767701262)
,p_display_sequence=>10
,p_display_value=>'Override Behaviour'
,p_return_value=>'OMB'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  When checked, attribute <strong>Override Behaviour</strong> is aviable to set. ',
'  Use this option to add submenu to existing List Entry, override action of List Entry,',
'  set function controlling disability of List Entry.',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(223337739869186446)
,p_plugin_attribute_id=>wwv_flow_api.id(223322603767701262)
,p_display_sequence=>20
,p_display_value=>'Add Extra Entries'
,p_return_value=>'EE'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  When checked, attribute <strong>Add Extra Entries</strong> is aviable to set. ',
'  Use this option to add entries to existing List. ',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(223340300569472768)
,p_plugin_attribute_id=>wwv_flow_api.id(223322603767701262)
,p_display_sequence=>30
,p_display_value=>'Fixed Position'
,p_return_value=>'FP'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  When checked, menu is positioned using <strong>fixed</strong> position and its position is not affected by scrolling.',
'  This option is helpful when menu is attached to button in breadcrumbs region.',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149768054484253465)
,p_plugin_attribute_id=>wwv_flow_api.id(223322603767701262)
,p_display_sequence=>40
,p_display_value=>'Display at Mouse Position'
,p_return_value=>'DAMP'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  <strong>This option doesn''t apply to html and APEX defined buttons!</strong>',
'</p>',
'<p>',
'  When checked, menu is positioned using mouse current X and Y coordinates. ',
'  Second parameter for action function is set to <strong>null</strong> and can''t be used to reference invoking DOM element.',
'  To reference DOM element invoking menu use <strong>$.proxy</strong> method which will override context of entry <strong>action</strong> function.',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(37922096665534989)
,p_plugin_attribute_id=>wwv_flow_api.id(223322603767701262)
,p_display_sequence=>50
,p_display_value=>'Narrow to Affected Elements'
,p_return_value=>'NTAE'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  When checked, a menu is bound with <strong>Affected Elements</strong> that are equal or are children of <strong>Triggering Element</strong>.',
'</p>',
'<p>',
'  When not checked, a menu is bound with <strong>Trigerring Element</strong>',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(37944228727155090)
,p_plugin_attribute_id=>wwv_flow_api.id(223322603767701262)
,p_display_sequence=>60
,p_display_value=>'Stop Event Propagation'
,p_return_value=>'SEP'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  When checked, keeps the rest of the handlers from being executed and prevents the <strong>dynamic action event</strong> from bubbling up the DOM tree.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(223329400544915113)
,p_plugin_id=>wwv_flow_api.id(267205648688277419)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Override Behaviour'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'//please read apex inline help text',
'return {};'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(223322603767701262)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'OMB'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  Examples describes defined list entry in ',
'  <i>Shared Components > Lists > List entry</i>',
'  with <strong>User Defined Attribute 1</strong>',
'  set to <strong>ENTRY_ATTR01_VALUE</strong>.',
'</p>',
'<strong>Overriding existing list entry bahaviour</strong>',
'<pre><code>return {',
'  "ENTRY_ATTR01_VALUE": {',
'    "action": function( pMenuOptions, pTriggeringElement ){',
'      //Code to be executed when users clicks on entry',
'      return void(0);',
'    },',
'    "disabled": function( pMenuOptions, pEntry ) {',
'      //Code to be executed to determine whether entry is disabled or enabled',
'      //return true to disable list entry',
'      return true;',
'    },',
'    "hide": function( pMenuOptions ){',
'      //Code to be executed to determine whether entry is rendered',
'      //return true to hide list entry',
'      return false;',
'    }',
'  }',
'};</code></pre>',
'',
'<strong>Adding submenu to existing list entry</strong>',
'<pre><code>return {',
'  "ENTRY_ATTR01_VALUE": {',
'    "items": [',
'      {',
'        "type": "subMenu", ',
'        "labelKey": "Label Text",',
'        "icon": "fa-pencil",',
'        "accelerator" : "",',
'        "href": "",',
'        "action": function(pMenuOptions, pTriggeringElement) {',
'          return void(0);',
'        },',
'        "disabled": function( pMenuOptions, pEntry ) {',
'          return false;',
'        },',
'        "hide": function( pMenuOptions ){',
'          return false;',
'        },',
'        //optional submenu of "Label Text" entry',
'        "items": [',
'          //Array of objests describing list Entries',
'          ...',
'        ]',
'      },',
'      ...',
'    ]',
'  }',
'};</code></pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  This code has access to the following dynamic action related attributes:',
'</p>',
'<dl>',
'  <dt><code>this.triggeringElement</code></dt>',
'    <dd>A reference to the DOM object of the element that triggered the dynamic action.</dd>',
'  <dt><code>this.affectedElements</code></dt>',
'    <dd>A jQuery object containing all the affected elements.</dd>',
'  <dt><code>this.action</code></dt>',
'    <dd>The action object containing details such as the action name and additional attribute values.</dd>',
'  <dt><code>this.browserEvent</code></dt>',
'     <dd>The event object of event that triggered the event. Note: On load this equals ''load''.</dd>',
'  <dt><code>this.data</code></dt>',
'    <dd>Optional additional data that can be passed from the event handler.</dd>',
'</dl>',
'<p>',
'  This code has access to the following plugin widget properties.',
'</p>',
'<dl>',
'  <dt><code>this.element</code></dt>',
'    <dd>A jQuery reference to the DOM object of the element that invoked a menu.</dd>',
'  <dt><code>this.id</code></dt>',
'    <dd>Unique identifier generated by the plugin to identify a menu container.</dd>',
'</dl>',
'<h4>Purpose</h4>',
'<p>',
'  This attribute can be used to <strong>extend existing list entry</strong>:',
'  <ul>',
'    <li>add submenu</li>',
'    <li>override action</li>',
'    <li>set disable property</li>',
'    <li>hide</li>',
'  </ul>',
'</p>',
'<p>',
'  Entry to be extended must has set <strong>User Defined Attribute 1</strong> to unique text - entry id.',
'</p>',
'<p>',
'  To learn about entry properties please refer oracle apex menu API ',
'  https://docs.oracle.com/database/apex-18.1/AEXJS/menu.html',
'</p>',
'<p>',
'  Supported properties are:',
'</p>',
'<ul>',
'  <li>type</li>',
'  <li>id</li>',
'  <li>label</li>',
'  <li>labelKey</li>',
'  <li>hide</li>',
'  <li>disabled</li>',
'  <li>icon</li>',
'  <li>iconStyle</li>',
'  <li>href</li>',
'  <li>action</li>',
'  <li>accelerator</li>',
'  <li>menu*</li>',
'</ul>',
'<p>',
'<code>* menu </code> property is implemented via property items to avoid unnecessary nested objects. See examples below.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(223335023763173222)
,p_plugin_id=>wwv_flow_api.id(267205648688277419)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Extra entries'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'//please read apex inline help text',
'return [];'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(223322603767701262)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'EE'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<strong>Add entries to existing list</strong>',
'<pre><code>return [',
'  {',
'    "seq": 10,',
'    "type": "action", ',
'    "labelKey": "Label Text",',
'    "icon": "fa-pencil",',
'    "accelerator" : "",',
'    "href": "",',
'    "action": function( pMenuOptions, pTriggeringElement ){',
'      //Code to be executed when users clicks on entry',
'      return void(0);',
'    },',
'    "disabled": function( pMenuOptions, pEntry ) {',
'      //Code to be executed to determine whether entry is disabled or enabled',
'      //return true to disable list entry',
'      return true;',
'    },',
'    "hide": function( pMenuOptions ){',
'      //Code to be executed to determine whether entry is rendered',
'      //return true to hide list entry',
'      return false;',
'    }',
'  },',
'  ...',
'];</code></pre>',
'',
'<strong>Add entries with submenu to existing list</strong>',
'<pre><code>return [ ',
'  {',
'    "seq": 10,',
'    "type": "subMenu", ',
'    "labelKey": "Label Text",',
'    "icon": "fa-pencil",',
'    "accelerator" : "",',
'    "disabled": function( pMenuOptions, pEntry ) {',
'      //Code to be executed to determine whether entry is disabled or enabled',
'      //return true to disable list entry',
'      return false;',
'    },',
'    "hide": function( pMenuOptions ){',
'      //Code to be executed to determine whether entry is rendered',
'      //return true to hide list entry',
'      return false;',
'    },',
'    "items": [',
'      {',
'        "seq": 20,',
'        "type": "action", ',
'        "labelKey": "Submenu entry",',
'        "icon": "fa-search",',
'        "accelerator" : "",',
'        "href": "",',
'        "action": function( pMenuOptions, pTriggeringElement ){',
'          //Code to be executed when users clicks on entry',
'          return void(0);',
'        },',
'        "disabled": function( pMenuOptions, pEntry ) {',
'          //Code to be executed to determine whether entry is disabled or enabled',
'          //return true to disable list entry',
'          return false;',
'        },',
'        "hide": function( pMenuOptions ){',
'          //Code to be executed to determine whether entry is rendered',
'          //return true to hide list entry',
'          return false;',
'        }',
'      },',
'      ...',
'    ]',
'  },',
'  ...',
'];</code></pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  This code has access to the following dynamic action related attributes:',
'</p>',
'<dl>',
'  <dt><code>this.triggeringElement</code></dt>',
'    <dd>A reference to the DOM object of the element that triggered the dynamic action.</dd>',
'  <dt><code>this.affectedElements</code></dt>',
'    <dd>A jQuery object containing all the affected elements.</dd>',
'  <dt><code>this.action</code></dt>',
'    <dd>The action object containing details such as the action name and additional attribute values.</dd>',
'  <dt><code>this.browserEvent</code></dt>',
'     <dd>The event object of event that triggered the event. Note: On load this equals ''load''.</dd>',
'  <dt><code>this.data</code></dt>',
'    <dd>Optional additional data that can be passed from the event handler.</dd>',
'</dl>',
'<p>',
'  This code has access to the following plugin widget properties.',
'</p>',
'<dl>',
'  <dt><code>this.element</code></dt>',
'    <dd>A jQuery reference to the DOM object of the element that invoked a menu.</dd>',
'  <dt><code>this.id</code></dt>',
'    <dd>Unique identifier generated by the plugin to identify a menu container.</dd>',
'</dl>',
'<h4>Purpose</h4>',
'<p>',
'  This attribute allows to add entries to existing list defined in',
'  <i>Shared Componenets > Lists</i>. Sequence order of list entries can be ',
'  set using <strong>seq</strong> property of each new item. ',
'</p>'))
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E20707265746975735F68616E646C655F64612820704A736F6E2029207B0D0A202072657475726E20242E657874656E642820746869732C207B0D0A20202020226F726754686973222020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(2) := '2020203A20242E657874656E64287B7D2C2074686973292C0D0A20202020226C6F67507265666978222020202020202020202020202020202020202020203A20272320272B746869732E616374696F6E2E616374696F6E2C0D0A20202020226576656E74';
wwv_flow_api.g_varchar2_table(3) := '496E7465726E616C4E616D6522202020202020202020202020203A20704A736F6E2E64612E5748454E5F4556454E545F494E5445524E414C5F4E414D452C0D0A20202020226576656E74437573746F6D4E616D6522202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(4) := '3A20704A736F6E2E64612E5748454E5F4556454E545F435553544F4D5F4E414D452C0D0A202020202264614E616D65222020202020202020202020202020202020202020202020203A20704A736F6E2E64612E44594E414D49435F414354494F4E5F4E41';
wwv_flow_api.g_varchar2_table(5) := '4D452C0D0A202020202264796E616D6963416374696F6E53636F7065222020202020202020202020203A20704A736F6E2E64612E5748454E5F4556454E545F53434F50452C0D0A2020202022747970652220202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(6) := '202020202020203A20704A736F6E2E747970652C0D0A2020202022656E74726965732220202020202020202020202020202020202020202020203A20704A736F6E2E656E74726965732C0D0A2020202022617474724E6172726F77546F41666665637465';
wwv_flow_api.g_varchar2_table(7) := '64456C656D656E74732220203A20746869732E616374696F6E2E61747472696275746530322E696E6465784F6628274E5441452729203E202D312C0D0A20202020226174747253746F70654576656E7450726F7061676174696F6E2220202020203A2074';
wwv_flow_api.g_varchar2_table(8) := '6869732E616374696F6E2E61747472696275746530322E696E6465784F6628275345502729203E202D312C0D0A20202020226765744C697374656E546F4576656E74223A2066756E6374696F6E28207044657374456C656D656E747320297B0D0A202020';
wwv_flow_api.g_varchar2_table(9) := '20202076617220636C69636B203D2027636C69636B273B0D0A0D0A2020202020206966202820746869732E6576656E74496E7465726E616C4E616D65203D3D2027726561647927202626207044657374456C656D656E74732E66696C7465722827627574';
wwv_flow_api.g_varchar2_table(10) := '746F6E27292E6C656E677468203D3D20302029207B0D0A202020202020202072657475726E20636C69636B3B0D0A2020202020207D0D0A202020202020656C7365206966202820746869732E6576656E74496E7465726E616C4E616D65203D3D20276170';
wwv_flow_api.g_varchar2_table(11) := '657861667465727265667265736827202626207044657374456C656D656E74732E66696C7465722827627574746F6E27292E6C656E677468203D3D20302029207B0D0A202020202020202072657475726E20636C69636B3B0D0A2020202020207D0D0A0D';
wwv_flow_api.g_varchar2_table(12) := '0A20202020202072657475726E206E756C6C3B0D0A202020207D2C0D0A202020202267657445787472614F7074696F6E73223A2066756E6374696F6E28207044657374456C656D656E747320297B0D0A20202020202072657475726E207B0D0A20202020';
wwv_flow_api.g_varchar2_table(13) := '202020202264796E616D6963416374696F6E53636F7065223A20746869732E64796E616D6963416374696F6E53636F70652C0D0A2020202020202020226973436F6E746578744D656E752220202020203A20746869732E6576656E74496E7465726E616C';
wwv_flow_api.g_varchar2_table(14) := '4E616D65203D3D2027637573746F6D2720262620746869732E6576656E74437573746F6D4E616D65203D3D2027636F6E746578746D656E7527203F2074727565203A2066616C73652C0D0A2020202020202020226C697374656E546F4576656E74222020';
wwv_flow_api.g_varchar2_table(15) := '2020203A20746869732E6765744C697374656E546F4576656E7428207044657374456C656D656E747320290D0A2020202020207D0D0A202020207D2C0D0A20202020227468726F774572726F72223A2066756E6374696F6E2820704572726F724D657373';
wwv_flow_api.g_varchar2_table(16) := '6167652C207053746F70457865637574696F6E20297B0D0A202020202020617065782E64656275672E6D6573736167652820617065782E64656275672E4C4F475F4C4556454C2E4552524F52202C20704572726F724D657373616765293B0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(17) := '20202020766172206D657373616765203D2027272B0D0A2020202020202020273C7374726F6E673E50726574697573204150455820436F6E74657874204D656E753C2F7374726F6E673E3C62723E272B0D0A20202020202020202F2F746869732E64614E';
wwv_flow_api.g_varchar2_table(18) := '616D652B273C62723E272B0D0A2020202020202020273C7370616E20636C6173733D2270726574697573617065786D656E756C6973742D6572726F724D657373616765223E272B704572726F724D6573736167652B273C2F7370616E3E273B0D0A0D0A20';
wwv_flow_api.g_varchar2_table(19) := '2020202020617065782E6D6573736167652E636C6561724572726F727328293B0D0A0D0A202020202020617065782E6D6573736167652E73686F774572726F727328207B0D0A2020202020202020747970653A20617065782E6D6573736167652E455252';
wwv_flow_api.g_varchar2_table(20) := '4F522C0D0A20202020202020206C6F636174696F6E3A202270616765222C0D0A20202020202020206D6573736167653A206D6573736167650D0A2020202020207D20293B0D0A0D0A20202020202069662028207053746F70457865637574696F6E202920';
wwv_flow_api.g_varchar2_table(21) := '7B0D0A20202020202020207468726F77202244796E616D696320616374696F6E2073746F7070656421223B0D0A2020202020207D0D0A0D0A202020207D2C0D0A20202020226765744E6172726F7765644166666563746564456C656D656E7473223A2066';
wwv_flow_api.g_varchar2_table(22) := '756E6374696F6E2820704E6172726F77546F4576656E7454617267657420297B0D0A202020202020766172200D0A20202020202020206E6172726F7765642C0D0A20202020202020206576656E74546172676574203D20746869732E62726F7773657245';
wwv_flow_api.g_varchar2_table(23) := '76656E742E7461726765743B0D0A202020202020202074726967676572696E67456C656D656E74203D20746869732E74726967676572696E67456C656D656E743B0D0A0D0A2020202020206E6172726F776564203D20242E6772657028746869732E6166';
wwv_flow_api.g_varchar2_table(24) := '666563746564456C656D656E74732C2066756E6374696F6E2870456C656D656E7429207B0D0A20202020202020206966202820242E636F6E7461696E732874726967676572696E67456C656D656E742C2070456C656D656E7429207C7C20747269676765';
wwv_flow_api.g_varchar2_table(25) := '72696E67456C656D656E74203D3D2070456C656D656E7429207B0D0A2020202020202020202072657475726E20747275653B0D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A2020202020202020202072657475726E2066616C73';
wwv_flow_api.g_varchar2_table(26) := '653B0D0A20202020202020207D0D0A2020202020207D293B0D0A0D0A2020202020206966202820704E6172726F77546F4576656E745461726765742029207B0D0A20202020202020206E6172726F776564203D20242E67726570286E6172726F7765642C';
wwv_flow_api.g_varchar2_table(27) := '2066756E6374696F6E2870456C656D656E7429207B0D0A202020202020202020206966202820242E636F6E7461696E732870456C656D656E742C206576656E74546172676574292029207B0D0A20202020202020202020202072657475726E2074727565';
wwv_flow_api.g_varchar2_table(28) := '3B0D0A202020202020202020207D0D0A20202020202020202020656C736520696620282070456C656D656E74203D3D206576656E745461726765742029207B0D0A20202020202020202020202072657475726E20747275653B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(29) := '207D0D0A20202020202020202020656C7365207B0D0A20202020202020202020202072657475726E2066616C73653B0D0A202020202020202020207D0D0A20202020202020207D293B0D0A0D0A2020202020207D0D0A0D0A20202020202072657475726E';
wwv_flow_api.g_varchar2_table(30) := '206E6172726F7765643B0D0A202020207D2C0D0A2020202022636865636B4461496D706C656D656E746174696F6E223A2066756E6374696F6E28297B0D0A2020202020206966202820746869732E616374696F6E2E6166666563746564456C656D656E74';
wwv_flow_api.g_varchar2_table(31) := '7354797065203D3D206E756C6C20262620746869732E6576656E74496E7465726E616C4E616D65203D3D20277265616479272029207B0D0A202020202020202072657475726E2027496E76616C69642044796E616D696320416374696F6E20636F6E6669';
wwv_flow_api.g_varchar2_table(32) := '6775726174696F6E3A2050616765204C6F6164206576656E7420726571756972657320616666656374656420656C656D656E747320746F20626520646566696E65642E273B0D0A2020202020207D0D0A2020202020200D0A202020202020656C73652069';
wwv_flow_api.g_varchar2_table(33) := '66202820746869732E616374696F6E2E6166666563746564456C656D656E747354797065203D3D206E756C6C20262620746869732E6576656E74496E7465726E616C4E616D65203D3D202761706578616674657272656672657368272029207B0D0A2020';
wwv_flow_api.g_varchar2_table(34) := '20202020202072657475726E2027496E76616C69642044796E616D696320416374696F6E20636F6E66696775726174696F6E3A2041667465722052656672657368206576656E7420726571756972657320616666656374656420656C656D656E74732074';
wwv_flow_api.g_varchar2_table(35) := '6F20626520646566696E65642E273B200D0A2020202020207D0D0A2020202020200D0A202020202020656C7365206966202820746869732E616374696F6E2E6166666563746564456C656D656E747354797065203D3D206E756C6C20262620746869732E';
wwv_flow_api.g_varchar2_table(36) := '617474724E6172726F77546F4166666563746564456C656D656E747329207B0D0A202020202020202072657475726E2027496E76616C69642044796E616D696320416374696F6E20636F6E66696775726174696F6E3A2061747472696275746520224E61';
wwv_flow_api.g_varchar2_table(37) := '72726F7720746F20616666656374656420656C656D656E74732220697320636865636B6564206275742022616666656374656420656C656D656E747322206973206E6F74207365742E273B0D0A2020202020207D0D0A2020202020200D0A202020202020';
wwv_flow_api.g_varchar2_table(38) := '656C73652069662028200D0A2020202020202020746869732E6576656E74496E7465726E616C4E616D65203D3D2027637573746F6D2720262620746869732E6576656E74437573746F6D4E616D6520213D2027636F6E746578746D656E7527200D0A2020';
wwv_flow_api.g_varchar2_table(39) := '202020202020262620746869732E617474724E6172726F77546F4166666563746564456C656D656E747320262620746869732E616374696F6E2E6166666563746564456C656D656E747354797065203D3D206E756C6C0D0A20202020202029207B0D0A20';
wwv_flow_api.g_varchar2_table(40) := '2020202020202072657475726E2027496E76616C696420437573746F6D204576656E7420436F6E66696775726174696F6E3A2061747472696275746520224E6172726F7720746F20616666656374656420656C656D656E74732220697320636865636B65';
wwv_flow_api.g_varchar2_table(41) := '64206275742022616666656374656420656C656D656E747322206973206E6F74207365742E273B0D0A2020202020207D0D0A202020202020656C736520696620280D0A2020202020202020746869732E6576656E74496E7465726E616C4E616D65203D3D';
wwv_flow_api.g_varchar2_table(42) := '2027637573746F6D2720262620746869732E6576656E74437573746F6D4E616D6520213D2027636F6E746578746D656E7527200D0A2020202020202020262620746869732E617474724E6172726F77546F4166666563746564456C656D656E7473203D3D';
wwv_flow_api.g_varchar2_table(43) := '2066616C7365200D0A2020202020202020262620746869732E64617461203D3D20756E646566696E65640D0A20202020202029207B0D0A202020202020202072657475726E2027496E76616C696420437573746F6D204576656E7420436F6E6669677572';
wwv_flow_api.g_varchar2_table(44) := '6174696F6E3A20746869732E6461746120697320756E646566696E65642E27203B0D0A2020202020207D0D0A0D0A202020202020656C736520696620280D0A2020202020202020746869732E6576656E74496E7465726E616C4E616D65203D3D20276375';
wwv_flow_api.g_varchar2_table(45) := '73746F6D2720262620746869732E6576656E74437573746F6D4E616D6520213D2027636F6E746578746D656E7527200D0A2020202020202020262620746869732E617474724E6172726F77546F4166666563746564456C656D656E7473203D3D2066616C';
wwv_flow_api.g_varchar2_table(46) := '7365200D0A2020202020202020262620746869732E646174612E656C656D656E74203D3D20756E646566696E65640D0A20202020202029207B0D0A202020202020202072657475726E2027496E76616C696420437573746F6D204576656E7420436F6E66';
wwv_flow_api.g_varchar2_table(47) := '696775726174696F6E3A20746869732E646174612E656C656D656E7420697320756E646566696E65642E270D0A2020202020207D2020202020200D0A0D0A202020202020656C7365206966202820242E696E41727261792820746869732E6576656E7449';
wwv_flow_api.g_varchar2_table(48) := '6E7465726E616C4E616D652C205B27636C69636B272C20277265616479272C2027637573746F6D272C202761706578616674657272656672657368275D2029203D3D202D312029207B0D0A202020202020202072657475726E20274E6F7420737570706F';
wwv_flow_api.g_varchar2_table(49) := '727465642044796E616D696320416374696F6E206576656E743A2022272B746869732E6576656E74496E7465726E616C4E616D652B27222E273B0D0A2020202020207D0D0A0D0A2020202020202F2F706F737369626C65206572726F7273206E6F742072';
wwv_flow_api.g_varchar2_table(50) := '61697365642C2072657475726E20747275653B0D0A0D0A20202020202072657475726E20747275653B0D0A202020207D2C0D0A202020202267657444657374456C656D656E7473223A2066756E6374696F6E28297B0D0A20202020202069662028207468';
wwv_flow_api.g_varchar2_table(51) := '69732E6576656E74496E7465726E616C4E616D65203D3D2027636C69636B272029207B0D0A202020202020202072657475726E20746869732E617474724E6172726F77546F4166666563746564456C656D656E7473203F20746869732E6765744E617272';
wwv_flow_api.g_varchar2_table(52) := '6F7765644166666563746564456C656D656E74732829203A20746869732E74726967676572696E67456C656D656E743B0D0A2020202020207D0D0A0D0A202020202020656C7365206966202820746869732E6576656E74496E7465726E616C4E616D6520';
wwv_flow_api.g_varchar2_table(53) := '3D3D2027637573746F6D2720262620746869732E6576656E74437573746F6D4E616D65203D3D2027636F6E746578746D656E75272029207B0D0A202020202020202072657475726E20746869732E617474724E6172726F77546F4166666563746564456C';
wwv_flow_api.g_varchar2_table(54) := '656D656E7473203F20746869732E6765744E6172726F7765644166666563746564456C656D656E74732820747275652029203A20746869732E74726967676572696E67456C656D656E743B0D0A2020202020207D0D0A0D0A202020202020656C73652069';
wwv_flow_api.g_varchar2_table(55) := '66202820746869732E6576656E74496E7465726E616C4E616D65203D3D2027637573746F6D2720262620746869732E6576656E74437573746F6D4E616D6520213D2027636F6E746578746D656E75272029207B0D0A0D0A20202020202020206966202820';
wwv_flow_api.g_varchar2_table(56) := '746869732E617474724E6172726F77546F4166666563746564456C656D656E74732029207B0D0A2020202020202020202072657475726E20746869732E6166666563746564456C656D656E74733B0D0A20202020202020207D0D0A202020202020202065';
wwv_flow_api.g_varchar2_table(57) := '6C7365207B0D0A2020202020202020202072657475726E20746869732E646174612E656C656D656E743B0D0A20202020202020207D0D0A2020202020207D0D0A0D0A202020202020656C7365206966202820746869732E6576656E74496E7465726E616C';
wwv_flow_api.g_varchar2_table(58) := '4E616D65203D3D20277265616479272029207B0D0A202020202020202072657475726E20746869732E6166666563746564456C656D656E74733B0D0A2020202020207D0D0A0D0A202020202020656C7365206966202820746869732E6576656E74496E74';
wwv_flow_api.g_varchar2_table(59) := '65726E616C4E616D65203D3D202761706578616674657272656672657368272029207B0D0A202020202020202072657475726E20746869732E617474724E6172726F77546F4166666563746564456C656D656E7473203F20746869732E6765744E617272';
wwv_flow_api.g_varchar2_table(60) := '6F7765644166666563746564456C656D656E74732829203A20746869732E6166666563746564456C656D656E74733B0D0A2020202020207D0D0A0D0A202020202020656C7365207B0D0A20202020202020202F2F6F74686572206576656E74206E6F7420';
wwv_flow_api.g_varchar2_table(61) := '737570706F727465640D0A20202020202020202F2F6E6F726D616C6C792066756E6374696F6E20636865636B4461496D706C656D656E746174696F6E2077696C6C207261697365206572726F720D0A20202020202020202F2F7261697365206572726F72';
wwv_flow_api.g_varchar2_table(62) := '3F0D0A202020202020202072657475726E20746869732E74726967676572696E67456C656D656E743B0D0A2020202020207D0D0A202020207D2C0D0A2020202022696E6974223A2066756E6374696F6E28297B0D0A202020202020766172200D0A202020';
wwv_flow_api.g_varchar2_table(63) := '202020202064657374456C656D656E7473203D20756E646566696E65642C0D0A202020202020202069734461436F6E666967757265642C0D0A20202020202020207769646765744F7074696F6E733B0D0A0D0A2020202020202F2F636865636B20696620';
wwv_flow_api.g_varchar2_table(64) := '64796E616D696320616374696F6E20697320636F6E666967757265642070726F7065726C790D0A20202020202069734461436F6E66696775726564203D20746869732E636865636B4461496D706C656D656E746174696F6E28293B0D0A0D0A2020202020';
wwv_flow_api.g_varchar2_table(65) := '206966202820747970656F662069734461436F6E66696775726564203D3D2027737472696E672729207B0D0A2020202020202020746869732E7468726F774572726F72282069734461436F6E666967757265642C207472756520293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(66) := '202072657475726E20766F69642830293B0D0A2020202020207D0D0A0D0A2020202020202F2F676574206465737420656C656D656E74206261736564206F6E206576656E7420747970652C2074726967676572696E6720656C656D656E742C2061666665';
wwv_flow_api.g_varchar2_table(67) := '6374656420656C656D656E747320616E6420706C7567696E2061747472696275746520224E6172726F7720746F20616666656374656420656C656D656E7473220D0A20202020202064657374456C656D656E7473203D20242820746869732E6765744465';
wwv_flow_api.g_varchar2_table(68) := '7374456C656D656E7473282920293B0D0A0D0A202020202020696620282064657374456C656D656E74732E6C656E677468203D3D20302029207B0D0A2020202020202020617065782E64656275672E6D6573736167652820617065782E64656275672E4C';
wwv_flow_api.g_varchar2_table(69) := '4F475F4C4556454C2E5741524E202C20746869732E6C6F675072656669782C202744796E616D696320616374696F6E2022272B746869732E64614E616D652B27222073746F707065643A206E6F20656C656D656E747320666F756E642127293B0D0A2020';
wwv_flow_api.g_varchar2_table(70) := '20202020202072657475726E20766F69642830293B0D0A2020202020207D0D0A202020202020656C7365207B0D0A2020202020202020617065782E64656275672E6D6573736167652820617065782E64656275672E4C4F475F4C4556454C2E494E464F20';
wwv_flow_api.g_varchar2_table(71) := '2C20746869732E6C6F675072656669782C202743726561746520636F6E74657874206D656E7520666F722064796E616D696320616374696F6E2022272B746869732E64614E616D652B2722272C2064657374456C656D656E7473293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(72) := '7D0D0A0D0A2020202020202F2F636865636B206D697865642074797065730D0A202020202020696620282064657374456C656D656E74732E66696C7465722827627574746F6E27292E6C656E677468203E20302026262064657374456C656D656E74732E';
wwv_flow_api.g_varchar2_table(73) := '66696C7465722827627574746F6E27292E6C656E67746820213D2064657374456C656D656E74732E6C656E6774682029207B0D0A20202020202020202F2F6D697865642074797065732028627574746F6E2026206F7468657229206973206E6F74207375';
wwv_flow_api.g_varchar2_table(74) := '70706F727465640D0A2020202020202020746869732E7468726F774572726F72282027496E76616C69642044796E616D696320416374696F6E20636F6E66696775726174696F6E3A20616666656374656420656C656D656E74732072657475726E696E67';
wwv_flow_api.g_varchar2_table(75) := '20627574746F6E7320616E64206F746865722048544D4C20444F4D20656C656D656E747320617265206E6F7420737570706F727465642E27202C207472756520293B0D0A202020202020202072657475726E20766F69642830293B0D0A2020202020207D';
wwv_flow_api.g_varchar2_table(76) := '0D0A0D0A0D0A2020202020206966202820746869732E6174747253746F70654576656E7450726F7061676174696F6E2029207B0D0A2020202020202020746869732E62726F777365724576656E742E70726576656E7444656661756C7428293B0D0A2020';
wwv_flow_api.g_varchar2_table(77) := '202020202020746869732E62726F777365724576656E742E73746F70496D6D65646961746550726F7061676174696F6E28293B0D0A2020202020202020617065782E64656275672E6D6573736167652820617065782E64656275672E4C4F475F4C455645';
wwv_flow_api.g_varchar2_table(78) := '4C2E4150505F5452414345202C20746869732E6C6F675072656669782C20274576656E742070726F7061676174696F6E2070726576656E7465642E27293B0D0A2020202020207D0D0A202020202020656C7365207B0D0A2020202020202020617065782E';
wwv_flow_api.g_varchar2_table(79) := '64656275672E6D6573736167652820617065782E64656275672E4C4F475F4C4556454C2E5741524E202C20746869732E6C6F675072656669782C20274576656E742069732070726F7061676174656420757020444F4D20747265652E27293B0D0A202020';
wwv_flow_api.g_varchar2_table(80) := '2020207D0D0A0D0A2020202020206C697374203D20207B0D0A2020202020202020226C697374223A207B0D0A20202020202020202020747970653A20746869732E747970652C0D0A20202020202020202020656E74726965733A20746869732E656E7472';
wwv_flow_api.g_varchar2_table(81) := '6965730D0A20202020202020207D0D0A2020202020207D3B0D0A0D0A2020202020207769646765744F7074696F6E73203D20242E657874656E64287B7D2C20746869732E6F7267546869732C206C6973742C20746869732E67657445787472614F707469';
wwv_flow_api.g_varchar2_table(82) := '6F6E73282064657374456C656D656E7473202920290D0A0D0A2020202020202F2F7462640D0A2020202020202F2F64657374456C656D656E74732E656163682829210D0A202020202020696620282064657374456C656D656E74732E6461746128277072';
wwv_flow_api.g_varchar2_table(83) := '65746975732D617065784C6973744D656E752729203D3D20756E646566696E65642029207B0D0A20202020202020200D0A20202020202020206966202820746869732E6461746120213D20756E646566696E656420262620746869732E646174612E6F70';
wwv_flow_api.g_varchar2_table(84) := '74696F6E7320213D20756E646566696E65642029207B0D0A202020202020202020202F2F696E2063617365206F6620637573746F6D206576656E74207769746820746869732E64617461207365742028656C656D656E7420616E64206F7074696F6E7329';
wwv_flow_api.g_varchar2_table(85) := '206F766572726964652064656661756C7420617474726962757465730D0A2020202020202020202064657374456C656D656E74732E617065784C6973744D656E7528242E657874656E64287769646765744F7074696F6E732C20746869732E646174612E';
wwv_flow_api.g_varchar2_table(86) := '6F7074696F6E732920293B20200D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A2020202020202020202064657374456C656D656E74732E617065784C6973744D656E75287769646765744F7074696F6E7320293B0D0A20202020';
wwv_flow_api.g_varchar2_table(87) := '202020207D0D0A2020202020207D0D0A202020202020656C7365207B0D0A202020202020202064657374456C656D656E74732E617065784C6973744D656E75282773686F77272C20746869732E62726F777365724576656E74293B0D0A2020202020207D';
wwv_flow_api.g_varchar2_table(88) := '0D0A0D0A20202020202072657475726E20766F69642830293B2020200D0A202020207D0D0A20207D293B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(149599283238392653)
,p_plugin_id=>wwv_flow_api.id(267205648688277419)
,p_file_name=>'pretius.handleDa.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E70726574697573617065786D656E756C6973742D6669786564207B0D0A2020706F736974696F6E3A20666978656421696D706F7274616E743B0D0A7D0D0A0D0A2E70726574697573617065786D656E756C6973742D6572726F724D657373616765207B';
wwv_flow_api.g_varchar2_table(2) := '0D0A2020666F6E742D73697A653A203930253B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(223373245570348262)
,p_plugin_id=>wwv_flow_api.id(267205648688277419)
,p_file_name=>'pretius.apexListMenu.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '242E7769646765742827707265746975732E617065784C6973744D656E75272C207B0D0A2F2F0D0A2020435F4552525F4D53475F45585452415F52455455524E5F554E444546494E4544203A2027457874726120456E74726965732072657475726E6564';
wwv_flow_api.g_varchar2_table(2) := '20756E646566696E65642E272C0D0A2020435F4552525F4D53475F45585452415F52455455524E5F494E56414C49442020203A2027457874726120456E74726965732072657475726E656420696E76616C6964206F626A6563742E272C0D0A2020435F45';
wwv_flow_api.g_varchar2_table(3) := '52525F4D53475F45585452415F455845435554455F4A53202020202020203A2027457874726120456E747269657320726169736564206572726F7220222530222E272C0D0A0D0A2020435F4552525F4D53475F455854454E445F455845435554455F4A53';
wwv_flow_api.g_varchar2_table(4) := '2020202020203A20274F76657272696465204265686176696F757220726169736564206572726F723A20222530222E272C0D0A2020435F4552525F4D53475F455854454E445F52455455524E5F494E56414C494420203A20274F76657272696465204265';
wwv_flow_api.g_varchar2_table(5) := '686176696F75722072657475726E656420696E76616C6964206F626A6563742E272C0D0A2F2F0D0A2020435F4C4F475F4445425547202020203A20617065782E64656275672E4C4F475F4C4556454C2E494E464F2C0D0A2020435F4C4F475F5741524E49';
wwv_flow_api.g_varchar2_table(6) := '4E4720203A20617065782E64656275672E4C4F475F4C4556454C2E5741524E2C0D0A2020435F4C4F475F4552524F52202020203A20617065782E64656275672E4C4F475F4C4556454C2E4552524F522C0D0A2020435F4C4F475F4C4556454C362020203A';
wwv_flow_api.g_varchar2_table(7) := '20617065782E64656275672E4C4F475F4C4556454C2E4150505F54524143452C0D0A2020435F4C4F475F4C4556454C392020203A20617065782E64656275672E4C4F475F4C4556454C2E454E47494E455F54524143452C0D0A0D0A2020435F454E545259';
wwv_flow_api.g_varchar2_table(8) := '5F545950455F414354494F4E202020203A2027616374696F6E272C0D0A2020435F454E5452595F545950455F5355424D454E552020203A20277375624D656E75272C0D0A2020435F454E5452595F545950455F534550415241544F52203A202773657061';
wwv_flow_api.g_varchar2_table(9) := '7261746F72272C0D0A0D0A2020435F504C5547494E5F4E414D45203A202750726574697573204150455820436F6E74657874204D656E75272C0D0A0D0A20205F6372656174653A2066756E6374696F6E28297B0D0A20202020746869732E5F7375706572';
wwv_flow_api.g_varchar2_table(10) := '2820746869732E6F7074696F6E7320293B0D0A0D0A20202020746869732E6C6F67507265666978203D20272320272B746869732E6F7074696F6E732E616374696F6E2E616374696F6E3B0D0A0D0A20202020617065782E64656275672E6D657373616765';
wwv_flow_api.g_varchar2_table(11) := '2820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C20275F637265617465272C20746869732E67657444656275674F626A6563742829293B0D0A0D0A202020206966202820746869732E6F7074696F6E732E6C697374';
wwv_flow_api.g_varchar2_table(12) := '2E74797065203D3D202753514C5F515545525927207C7C20746869732E6F7074696F6E732E6C6973742E74797065203D3D202746554E4354494F4E5F52455455524E494E475F53514C5F515545525927202920207B0D0A202020202020617065782E6465';
wwv_flow_api.g_varchar2_table(13) := '6275672E6D6573736167652820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C20275F637265617465272C2027636F6E766572742064796E616D6963206C69737420717565727920726573756C7427293B0D0A202020';
wwv_flow_api.g_varchar2_table(14) := '202020746869732E6F7074696F6E732E6C6973742E656E7472696573203D20746869732E5F636F6E766572744F626A65637428293B0D0A202020207D0D0A0D0A20202020746869732E697356697369626C65203D2066616C73653B0D0A0D0A2020202074';
wwv_flow_api.g_varchar2_table(15) := '6869732E756E69717565496420203D202428273C6469763E3C2F6469763E27292E756E69717565496428292E617474722827696427293B0D0A20202020746869732E6576656E744E616D6553706163652020203D20746869732E6F7074696F6E732E6163';
wwv_flow_api.g_varchar2_table(16) := '74696F6E2E616374696F6E2B272D272B746869732E756E6971756549643B0D0A0D0A202020206966202820746869732E656C656D656E7420213D20646F63756D656E742029207B0D0A202020202020746869732E656C656D656E740D0A20202020202020';
wwv_flow_api.g_varchar2_table(17) := '202E61747472287B0D0A2020202020202020202022646174612D6D656E75223A20746869732E756E6971756549642C0D0A2020202020202020202022617269612D686173706F707570223A20747275652C0D0A2020202020202020202022617269612D65';
wwv_flow_api.g_varchar2_table(18) := '7870616E646564223A2066616C73650D0A20202020202020207D290D0A20202020202020202E616464436C61737328276A732D6D656E75427574746F6E27293B0D0A202020207D0D0A0D0A20202020746869732E6D656E75436F6E7461696E6572203D20';
wwv_flow_api.g_varchar2_table(19) := '746869732E5F6372656174654D656E75436F6E7461696E657228293B0D0A20202020746869732E6D656E75436F6E7461696E65722E617070656E64546F2822626F647922293B202020200D0A0D0A20202020746869732E657874656E644A534F4E202020';
wwv_flow_api.g_varchar2_table(20) := '3D20746869732E5F676574457874656E644A736F6E28293B0D0A20202020746869732E6578747261456E7472696573203D20746869732E5F6765744578747261456E747269657328293B202020200D0A0D0A20202020746869732E6D656E75436F6E6669';
wwv_flow_api.g_varchar2_table(21) := '67203D20746869732E5F617065784372656174654D656E754A736F6E28293B0D0A0D0A20202020696620282021746869732E656C656D656E742E69732827627574746F6E27292029207B0D0A0D0A202020202020746869732E656C656D656E742E6F6E28';
wwv_flow_api.g_varchar2_table(22) := '276B6579646F776E272C20242E70726F78792866756E6374696F6E2820704576656E7420297B0D0A0D0A20202020202020206966202820704576656E742E7768696368203D3D20242E75692E6B6579436F64652E444F574E2029207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(23) := '20202020704576656E742E73746F70496D6D65646961746550726F7061676174696F6E28293B0D0A20202020202020202020704576656E742E70726576656E7444656661756C7428293B0D0A202020202020202020200D0A202020202020202020207468';
wwv_flow_api.g_varchar2_table(24) := '69732E5F706572666F726D46616B65436C69636B4576656E7428293B0D0A20202020202020207D0D0A20200D0A2020202020207D2C207468697329290D0A202020207D0D0A0D0A20202020617065782E64656275672E6D6573736167652820746869732E';
wwv_flow_api.g_varchar2_table(25) := '435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F637265617465272C2027696E69742041504558206D656E75206F6E20656C656D656E7427293B0D0A202020200D0A20202020746869732E6D656E75436F6E7461696E6572';
wwv_flow_api.g_varchar2_table(26) := '2E6D656E752820746869732E6D656E75436F6E66696720293B0D0A202020200D0A202020206966202820746869732E6F7074696F6E732E6973436F6E746578744D656E752029207B0D0A202020202020617065782E64656275672E6D6573736167652820';
wwv_flow_api.g_varchar2_table(27) := '746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C20275F637265617465272C2027666F7263652073686F77206D6574686F6420666F7220636F6E74657874206D656E75206576656E7427293B0D0A202020202020746869';
wwv_flow_api.g_varchar2_table(28) := '732E73686F772820746869732E6F7074696F6E732E62726F777365724576656E7420293B0D0A202020207D0D0A0D0A202020206966202820746869732E6F7074696F6E732E62726F777365724576656E742E74797065203D3D2022636C69636B22202920';
wwv_flow_api.g_varchar2_table(29) := '7B0D0A2020202020206966202820746869732E6F7074696F6E732E616374696F6E2E657865637574654F6E50616765496E6974203D3D2066616C73652029207B0D0A20202020202020206966202820746869732E6F7074696F6E732E64796E616D696341';
wwv_flow_api.g_varchar2_table(30) := '6374696F6E53636F7065203D3D20226C697665222029207B0D0A20202020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C20275F637265617465272C';
wwv_flow_api.g_varchar2_table(31) := '2027666F7263652073686F77206D6574686F6420666F7220636C69636B206576656E7420776974682064796E616D69632073636F706527293B0D0A0D0A20202020202020202020746869732E5F706572666F726D46616B65436C69636B4576656E742820';
wwv_flow_api.g_varchar2_table(32) := '7472756520293B0D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A20202020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C20';
wwv_flow_api.g_varchar2_table(33) := '275F637265617465272C2027666F7263652073686F77206D6574686F6420666F7220636C69636B206576656E7420776974686F757420696E697469616C697A6174696F6E206F6E2070616765206C6F6164206576656E742E27293B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(34) := '202020746869732E73686F772820746869732E6F7074696F6E732E62726F777365724576656E7420293B0D0A20202020202020207D0D0A2020202020207D0D0A0D0A202020207D0D0A0D0A202020206966202820746869732E6F7074696F6E732E6C6973';
wwv_flow_api.g_varchar2_table(35) := '74656E546F4576656E7420213D206E756C6C2029207B0D0A202020202020746869732E656C656D656E742E6F6E2820746869732E6F7074696F6E732E6C697374656E546F4576656E742C20242E70726F787928746869732E73686F772C20746869732920';
wwv_flow_api.g_varchar2_table(36) := '293B0D0A202020207D0D0A202020200D0A20207D2C0D0A0D0A20205F706572666F726D46616B65436C69636B4576656E743A2066756E6374696F6E282070466F72636520297B0D0A20202020617065782E64656275672E6D657373616765282074686973';
wwv_flow_api.g_varchar2_table(37) := '2E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F706572666F726D46616B65436C69636B4576656E74272C2027746869732E656C656D656E74272C20746869732E656C656D656E74293B0D0A0D0A202020207661722065';
wwv_flow_api.g_varchar2_table(38) := '203D206A51756572792E4576656E74282027636C69636B272C207B200D0A2020202020207461726765743A20746869732E656C656D656E742E6765742830292C0D0A20202020202070616765583A20746869732E656C656D656E742E6F66667365742829';
wwv_flow_api.g_varchar2_table(39) := '2E6C6566742C0D0A20202020202070616765593A20746869732E656C656D656E742E6F666673657428292E746F702B746869732E656C656D656E742E6F7574657248656967687428290D0A202020207D20293B0D0A0D0A20202020746869732E73686F77';
wwv_flow_api.g_varchar2_table(40) := '2820652C2070466F72636520293B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F64657374726F793A2066756E6374696F6E28297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C207468';
wwv_flow_api.g_varchar2_table(41) := '69732E6C6F675072656669782C20275F64657374726F79272C2027746869732E656C656D656E74272C20746869732E656C656D656E74293B0D0A202020202F2F75737577616A2077737A7973746B6965206E61646D6961726F776520656C656D656E7479';
wwv_flow_api.g_varchar2_table(42) := '2069206D656E75206B746F7265206F7361647A696C6573207720626F64790D0A0D0A202020207472797B0D0A202020202020746869732E6D656E75436F6E7461696E65722E72656D6F766528293B0D0A202020207D2063617463682820704572726F7220';
wwv_flow_api.g_varchar2_table(43) := '297B0D0A202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4552524F522C20746869732E6C6F675072656669782C20275F64657374726F792072656D6F76696E67206D656E7520636F6E7461696E6572207261';
wwv_flow_api.g_varchar2_table(44) := '69736564206572726F65272C20704572726F722E6D657373616765293B0D0A202020207D0D0A202020200D0A202020207472797B0D0A202020202020746869732E656C656D656E742E72656D6F7665436C617373282769732D61637469766527293B0D0A';
wwv_flow_api.g_varchar2_table(45) := '202020202020746869732E656C656D656E742E72656D6F7665417474722827646174612D6D656E7527293B0D0A202020202020746869732E656C656D656E742E72656D6F7665417474722827617269612D686173706F70757027293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(46) := '746869732E656C656D656E742E72656D6F7665417474722827617269612D657870616E64656427293B0D0A0D0A202020202020746869732E656C656D656E742E72656D6F7665436C61737328276A732D6D656E75427574746F6E27293B0D0A202020200D';
wwv_flow_api.g_varchar2_table(47) := '0A202020207D63617463682820704572726F722029207B0D0A202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4552524F522C20746869732E6C6F675072656669782C20275F64657374726F792072656D6F76';
wwv_flow_api.g_varchar2_table(48) := '696E6720746869732E656C656D656E74206174747269627574657320726169736564206572726F72272C20704572726F722E6D657373616765293B0D0A202020207D0D0A0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F7365744F7074696F6E3A206675';
wwv_flow_api.g_varchar2_table(49) := '6E6374696F6E2820704B65792C207056616C75652029207B0D0A202020206966202820704B6579203D3D3D202276616C7565222029207B0D0A2020202020207056616C7565203D20746869732E5F636F6E73747261696E28207056616C756520293B0D0A';
wwv_flow_api.g_varchar2_table(50) := '202020207D0D0A0D0A20202020746869732E5F73757065722820704B65792C207056616C756520293B0D0A20207D2C20200D0A20206F7074696F6E733A2066756E6374696F6E2820704F7074696F6E7320297B0D0A20202020746869732E5F7375706572';
wwv_flow_api.g_varchar2_table(51) := '2820704F7074696F6E7320293B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F7365744F7074696F6E733A2066756E6374696F6E2820704F7074696F6E732029207B0D0A20202020746869732E5F73757065722820704F7074696F6E7320293B0D0A2020';
wwv_flow_api.g_varchar2_table(52) := '7D2C0D0A2F2F0D0A2F2F0D0A20205F6372656174654D656E75436F6E7461696E65723A2066756E6374696F6E28297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F67';
wwv_flow_api.g_varchar2_table(53) := '5072656669782C20275F6372656174654D656E75436F6E7461696E657227293B0D0A0D0A2020202076617220646976203D20242820273C6469762069643D22272B746869732E756E6971756549642B27223E3C2F6469763E2720293B0D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(54) := '6966202820746869732E5F61747472466978506F736974696F6E28292029207B0D0A2020202020206469762E616464436C617373282770726574697573617065786D656E756C6973742D666978656427293B0D0A202020207D0D0A0D0A20202020726574';
wwv_flow_api.g_varchar2_table(55) := '75726E206469763B0D0A20207D2C0D0A20205F67657446756E6374696F6E436F6E746578743A2066756E6374696F6E28297B0D0A202020207661722072657475726E4F626A6563743B0D0A202020200D0A2020202072657475726E4F626A656374203D20';
wwv_flow_api.g_varchar2_table(56) := '7B0D0A20202020202022656C656D656E74223A20746869732E656C656D656E742C0D0A202020202020226964223A20746869732E756E6971756549640D0A202020207D3B0D0A0D0A20202020617065782E64656275672E6D657373616765282074686973';
wwv_flow_api.g_varchar2_table(57) := '2E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F67657446756E6374696F6E436F6E74657874272C2072657475726E4F626A656374293B0D0A2020202072657475726E2072657475726E4F626A6563743B0D0A20207D2C';
wwv_flow_api.g_varchar2_table(58) := '0D0A20205F6765744578747261456E74726965733A2066756E6374696F6E28297B0D0A20202020766172200D0A20202020202066756E632C0D0A20202020202066756E63426F6479203D2022222C0D0A202020202020726573756C74203D205B5D3B0D0A';
wwv_flow_api.g_varchar2_table(59) := '0D0A202020206966202820746869732E5F617474724164644578747261456E747269657328292029207B0D0A202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F67507265';
wwv_flow_api.g_varchar2_table(60) := '6669782C20275F6765744578747261456E747269657327293B0D0A0D0A202020202020747279207B0D0A202020202020202066756E63426F6479203D2022222B0D0A2020202020202020202022746869732E74726967676572696E67456C656D656E7420';
wwv_flow_api.g_varchar2_table(61) := '3D207054726967676572696E67456C656D656E743B205C6E222B0D0A2020202020202020202022746869732E6166666563746564456C656D656E7473203D20706166666563746564456C656D656E74733B205C6E222B0D0A202020202020202020202274';
wwv_flow_api.g_varchar2_table(62) := '6869732E616374696F6E203D2070416374696F6E3B205C6E222B0D0A2020202020202020202022746869732E62726F777365724576656E74203D207042726F777365724576656E743B205C6E222B0D0A2020202020202020202022746869732E64617461';
wwv_flow_api.g_varchar2_table(63) := '203D2070446174613B205C6E222B0D0A2020202020202020202022222B746869732E6F7074696F6E732E616374696F6E2E61747472696275746530342B225C6E222B0D0A2020202020202020202022223B0D0A202020202020202020200D0A2020202020';
wwv_flow_api.g_varchar2_table(64) := '20202066756E63203D206E65772046756E6374696F6E28200D0A20202020202020202020227054726967676572696E67456C656D656E74222C200D0A2020202020202020202022706166666563746564456C656D656E7473222C200D0A20202020202020';
wwv_flow_api.g_varchar2_table(65) := '2020202270416374696F6E222C200D0A20202020202020202020227042726F777365724576656E74222C200D0A20202020202020202020227044617461222C200D0A2020202020202020202066756E63426F6479200D0A2020202020202020293B0D0A0D';
wwv_flow_api.g_varchar2_table(66) := '0A2020202020202020726573756C74203D2066756E632E63616C6C280D0A20202020202020202020746869732E5F67657446756E6374696F6E436F6E7465787428292C200D0A20202020202020202020746869732E6F7074696F6E732E74726967676572';
wwv_flow_api.g_varchar2_table(67) := '696E67456C656D656E742C200D0A20202020202020202020746869732E6F7074696F6E732E6166666563746564456C656D656E74732C200D0A20202020202020202020746869732E6F7074696F6E732E616374696F6E2C200D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(68) := '746869732E6F7074696F6E732E62726F777365724576656E742C200D0A20202020202020202020746869732E6F7074696F6E732E64617461200D0A2020202020202020293B202020202020200D0A0D0A2020202020202020617065782E64656275672E6D';
wwv_flow_api.g_varchar2_table(69) := '6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F6765744578747261456E7472696573272C2027726573756C74272C20726573756C74293B20202020202020200D0A0D0A20202020202020';
wwv_flow_api.g_varchar2_table(70) := '20666F72202820766172206920696E20726573756C742029207B0D0A20202020202020202020726573756C745B695D2E534551203D20726573756C745B695D2E7365713B0D0A2020202020202020202064656C65746520726573756C745B695D2E736571';
wwv_flow_api.g_varchar2_table(71) := '3B0D0A20202020202020207D0D0A0D0A2020202020207D2063617463682820704572726F722029207B0D0A2020202020202020746869732E5F7072696E7446756E6374696F6E546F436F6E736F6C6528746869732E6F7074696F6E732E616374696F6E2E';
wwv_flow_api.g_varchar2_table(72) := '6174747269627574653034293B0D0A2020202020202020746869732E5F7468726F774572726F722820746869732E435F4552525F4D53475F45585452415F455845435554455F4A532C20704572726F722E6D65737361676520293B0D0A2020202020207D';
wwv_flow_api.g_varchar2_table(73) := '0D0A0D0A2020202020206966202820726573756C74203D3D20756E646566696E65642029207B0D0A20202020202020202F2F6E6F20726573756C742066726F6D2066756E6374696F6E0D0A2020202020202020746869732E5F7468726F774572726F7228';
wwv_flow_api.g_varchar2_table(74) := '20746869732E435F4552525F4D53475F45585452415F52455455524E5F554E444546494E454420293B0D0A2020202020207D0D0A202020202020656C73652069662028202128726573756C7420696E7374616E63656F66204172726179292029207B0D0A';
wwv_flow_api.g_varchar2_table(75) := '20202020202020202F2F746869732E5F7468726F774572726F722820274F76657272696465204265686176696F75722072657475726E656420696E76616C6964206F626A6563742E2720293B0D0A2020202020202020746869732E5F7468726F77457272';
wwv_flow_api.g_varchar2_table(76) := '6F722820746869732E435F4552525F4D53475F45585452415F52455455524E5F494E56414C494420293B0D0A2020202020207D0D0A202020207D0D0A0D0A202020200D0A2020202072657475726E20726573756C743B0D0A20207D2C0D0A20205F636865';
wwv_flow_api.g_varchar2_table(77) := '636B457874656E644A736F6E3A2066756E6374696F6E2820704C6973742C2070496420297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F';
wwv_flow_api.g_varchar2_table(78) := '636865636B457874656E644A736F6E27293B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F636865636B457874656E644A736F6E206C6973';
wwv_flow_api.g_varchar2_table(79) := '74272C20704C697374293B20202020202020200D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F636865636B457874656E644A736F6E206174';
wwv_flow_api.g_varchar2_table(80) := '74723130272C20704964293B0D0A0D0A2020202076617220666F756E64203D2066616C73653B0D0A0D0A20202020666F72202820766172206920696E20704C69737429207B0D0A2020202020206966202820704C6973745B695D2E454E5452595F415454';
wwv_flow_api.g_varchar2_table(81) := '5249425554455F3031203D3D207049642029207B0D0A2020202020202020666F756E64203D20747275653B0D0A2020202020202020627265616B3B0D0A2020202020207D0D0A0D0A2020202020206966202820704C6973745B695D2E6974656D7320213D';
wwv_flow_api.g_varchar2_table(82) := '20756E646566696E656420262620704C6973745B695D2E6974656D7320696E7374616E63656F6620417272617929207B0D0A2020202020202020666F756E64203D20746869732E5F636865636B457874656E644A736F6E2820704C6973745B695D2E6974';
wwv_flow_api.g_varchar2_table(83) := '656D732C2070496420293B0D0A2020202020207D0D0A202020207D0D0A0D0A2020202072657475726E20666F756E643B0D0A20207D2C0D0A20205F676574457874656E644A736F6E3A2066756E6374696F6E28297B0D0A20202020766172200D0A202020';
wwv_flow_api.g_varchar2_table(84) := '20202066756E632C0D0A20202020202066756E63426F6479203D2022222C0D0A202020202020726573756C74203D207B7D2C0D0A2020202020206C697374436F7079203D20242E657874656E64285B5D2C20746869732E6F7074696F6E732E6C6973742E';
wwv_flow_api.g_varchar2_table(85) := '656E7472696573292C0D0A202020202020636865636B526573756C743B0D0A2020202020200D0A0D0A0D0A202020206966202820746869732E5F617474724F766572726964654265686176696F757228292029207B0D0A202020202020617065782E6465';
wwv_flow_api.g_varchar2_table(86) := '6275672E6D6573736167652820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C20275F676574457874656E644A736F6E27293B2020202020200D0A0D0A2020202020207472797B0D0A202020202020202066756E6342';
wwv_flow_api.g_varchar2_table(87) := '6F6479203D2022222B0D0A2020202020202020202022746869732E74726967676572696E67456C656D656E74203D207054726967676572696E67456C656D656E743B205C6E222B0D0A2020202020202020202022746869732E6166666563746564456C65';
wwv_flow_api.g_varchar2_table(88) := '6D656E747320203D20706166666563746564456C656D656E74733B205C6E222B0D0A2020202020202020202022746869732E616374696F6E2020202020202020202020203D2070416374696F6E3B205C6E222B0D0A202020202020202020202274686973';
wwv_flow_api.g_varchar2_table(89) := '2E62726F777365724576656E742020202020203D207042726F777365724576656E743B205C6E222B0D0A2020202020202020202022746869732E6461746120202020202020202020202020203D2070446174613B205C6E222B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(90) := '2022222B746869732E6F7074696F6E732E616374696F6E2E61747472696275746530332B225C6E222B0D0A2020202020202020202022223B0D0A0D0A202020202020202066756E63203D206E65772046756E6374696F6E28200D0A202020202020202020';
wwv_flow_api.g_varchar2_table(91) := '20227054726967676572696E67456C656D656E74222C200D0A2020202020202020202022706166666563746564456C656D656E7473222C200D0A202020202020202020202270416374696F6E222C200D0A20202020202020202020227042726F77736572';
wwv_flow_api.g_varchar2_table(92) := '4576656E74222C200D0A20202020202020202020227044617461222C200D0A2020202020202020202066756E63426F6479200D0A2020202020202020293B0D0A0D0A2020202020202020726573756C74203D2066756E632E63616C6C28200D0A20202020';
wwv_flow_api.g_varchar2_table(93) := '202020202020746869732E5F67657446756E6374696F6E436F6E7465787428292C200D0A20202020202020202020746869732E6F7074696F6E732E74726967676572696E67456C656D656E742C200D0A20202020202020202020746869732E6F7074696F';
wwv_flow_api.g_varchar2_table(94) := '6E732E6166666563746564456C656D656E74732C200D0A20202020202020202020746869732E6F7074696F6E732E616374696F6E2C200D0A20202020202020202020746869732E6F7074696F6E732E62726F777365724576656E742C200D0A2020202020';
wwv_flow_api.g_varchar2_table(95) := '2020202020746869732E6F7074696F6E732E64617461200D0A2020202020202020293B0D0A0D0A2020202020207D2063617463682820704572726F722029207B0D0A2020202020202020746869732E5F7072696E7446756E6374696F6E546F436F6E736F';
wwv_flow_api.g_varchar2_table(96) := '6C6528746869732E6F7074696F6E732E616374696F6E2E6174747269627574653033293B0D0A2020202020202020746869732E5F7468726F774572726F722820746869732E435F4552525F4D53475F455854454E445F455845435554455F4A532C207045';
wwv_flow_api.g_varchar2_table(97) := '72726F722E6D65737361676520293B0D0A2020202020207D0D0A0D0A202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F676574457874656E64';
wwv_flow_api.g_varchar2_table(98) := '4A736F6E20726573756C74272C20726573756C74293B0D0A0D0A20202020202069662028202128726573756C7420696E7374616E63656F66204F626A65637429207C7C20726573756C7420696E7374616E63656F662041727261792029207B0D0A202020';
wwv_flow_api.g_varchar2_table(99) := '2020202020746869732E5F7468726F774572726F722820746869732E435F4552525F4D53475F455854454E445F52455455524E5F494E56414C494420293B0D0A2020202020207D0D0A2020202020202F2F74626420696E206E65787420726C656173653A';
wwv_flow_api.g_varchar2_table(100) := '206D6F72652064657461696C656420636865636B206F6E206F626A65637420747970653B0D0A0D0A2020202020202F2F636865636B2069662069647320726570726573656E7473206C697374730D0A202020202020666F72202820766172206920696E20';
wwv_flow_api.g_varchar2_table(101) := '726573756C742029207B0D0A2020202020202020636865636B526573756C74203D20746869732E5F636865636B457874656E644A736F6E28206C697374436F70792C206920293B0D0A0D0A2020202020202020696620282021636865636B526573756C74';
wwv_flow_api.g_varchar2_table(102) := '2029207B0D0A20202020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F5741524E494E472C20746869732E6C6F675072656669782C20275F676574457874656E644A736F6E207468657265206973206E6F20';
wwv_flow_api.g_varchar2_table(103) := '656E74727920776974682061747472696275746520312073657420746F2022272B692B272227293B0D0A20202020202020207D0D0A2020202020207D0D0A202020207D0D0A0D0A2020202072657475726E20726573756C743B0D0A20207D2C0D0A20205F';
wwv_flow_api.g_varchar2_table(104) := '6170657843616C6C6261636B4166746572436C6F73653A2066756E6374696F6E2820704576656E742C2070556920297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C2020746869732E6C';
wwv_flow_api.g_varchar2_table(105) := '6F675072656669782C20275F6170657843616C6C6261636B4166746572436C6F736527293B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F';
wwv_flow_api.g_varchar2_table(106) := '6170657843616C6C6261636B4166746572436C6F7365272C2027704576656E74272C20704576656E74293B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F6750726566';
wwv_flow_api.g_varchar2_table(107) := '69782C20275F6170657843616C6C6261636B4166746572436C6F7365272C2027705569272020202C20705569293B0D0A0D0A20202020746869732E697356697369626C65203D2066616C73653B0D0A0D0A202020206966202820746869732E6F7074696F';
wwv_flow_api.g_varchar2_table(108) := '6E732E6973436F6E746578744D656E752029207B0D0A202020202020746869732E64657374726F7928293B20200D0A202020207D0D0A0D0A2020202069662028207055692E6C61756E63686572203D3D206E756C6C20262620746869732E5F6174747244';
wwv_flow_api.g_varchar2_table(109) := '6973706C617941744D6F757365506F736974696F6E28292029207B0D0A202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F44454255472C2020746869732E6C6F675072656669782C20275F6170657843616C6C';
wwv_flow_api.g_varchar2_table(110) := '6261636B4166746572436C6F7365272C2027666F72636520666F63757320746F2074726967676572696E6720656C656D656E742E27293B0D0A202020202020746869732E656C656D656E742E666F63757328293B0D0A202020207D0D0A20207D2C0D0A20';
wwv_flow_api.g_varchar2_table(111) := '205F6170657843616C6C6261636B4265666F72654F70656E3A2066756E6374696F6E2820704576656E742C2070556920297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C202074686973';
wwv_flow_api.g_varchar2_table(112) := '2E6C6F675072656669782C20275F6170657843616C6C6261636B4265666F72654F70656E27293B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20';
wwv_flow_api.g_varchar2_table(113) := '275F6170657843616C6C6261636B4265666F72654F70656E272C2027704576656E74272C20704576656E74293B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072';
wwv_flow_api.g_varchar2_table(114) := '656669782C20275F6170657843616C6C6261636B4265666F72654F70656E272C2027705569272020202C20705569293B0D0A0D0A20202020746869732E697356697369626C65203D20747275653B0D0A0D0A20207D2C0D0A20205F6170657843616C6C62';
wwv_flow_api.g_varchar2_table(115) := '61636B4372656174653A2066756E6374696F6E2820704576656E742C2070556920297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C2020746869732E6C6F675072656669782C20275F61';
wwv_flow_api.g_varchar2_table(116) := '70657843616C6C6261636B43726561746527293B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F6170657843616C6C6261636B4372656174';
wwv_flow_api.g_varchar2_table(117) := '65272C2027704576656E74272C20704576656E74293B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F6170657843616C6C6261636B437265';
wwv_flow_api.g_varchar2_table(118) := '617465272C2027705569272020202C20705569293B0D0A20207D2C0D0A20202F2F68747470733A2F2F737461636B6F766572666C6F772E636F6D2F7175657374696F6E732F313132393231362F736F72742D61727261792D6F662D6F626A656374732D62';
wwv_flow_api.g_varchar2_table(119) := '792D737472696E672D70726F70657274792D76616C75650D0A20205F736F727441727261793A2066756E6374696F6E28207050726F70657274792029207B0D0A2020202076617220736F72744F72646572203D20313B0D0A0D0A202020207050726F7065';
wwv_flow_api.g_varchar2_table(120) := '727479203D207050726F70657274792E746F55707065724361736528293B0D0A0D0A202020206966287050726F70657274795B305D203D3D3D20222D2229207B0D0A2020202020202020736F72744F72646572203D202D313B0D0A202020202020202070';
wwv_flow_api.g_varchar2_table(121) := '50726F7065727479203D207050726F70657274792E7375627374722831293B0D0A202020207D0D0A2020202072657475726E2066756E6374696F6E2028612C6229207B0D0A202020202020202076617220726573756C74203D2028615B7050726F706572';
wwv_flow_api.g_varchar2_table(122) := '74795D203C20625B7050726F70657274795D29203F202D31203A2028615B7050726F70657274795D203E20625B7050726F70657274795D29203F2031203A20303B0D0A202020202020202072657475726E20726573756C74202A20736F72744F72646572';
wwv_flow_api.g_varchar2_table(123) := '3B0D0A202020207D202020200D0A20207D2C0D0A20205F617065784372656174654D656E754A736F6E3A2066756E6374696F6E28297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C2074';
wwv_flow_api.g_varchar2_table(124) := '6869732E6C6F675072656669782C20275F617065784372656174654D656E754A736F6E27293B0D0A0D0A20202020766172200D0A2020202020206D656E75203D207B0D0A20202020202020206166746572436C6F73653A20242E70726F78792820746869';
wwv_flow_api.g_varchar2_table(125) := '732E5F6170657843616C6C6261636B4166746572436C6F73652C2074686973292C0D0A20202020202020206265666F72654F70656E3A20242E70726F78792820746869732E5F6170657843616C6C6261636B4265666F72654F70656E2C2074686973292C';
wwv_flow_api.g_varchar2_table(126) := '0D0A2020202020202020637265617465202020203A20242E70726F78792820746869732E5F6170657843616C6C6261636B4372656174652C2074686973292C0D0A202020202020202069636F6E5479706520203A20226661220D0A2020202020207D2C0D';
wwv_flow_api.g_varchar2_table(127) := '0A2020202020206C697374436F7079203D20242E657874656E64285B5D2C20746869732E6F7074696F6E732E6C6973742E656E7472696573292C0D0A20202020202072656D6F7665643B0D0A0D0A2F2A0D0A202020202F2F72656D6F7665206C69737420';
wwv_flow_api.g_varchar2_table(128) := '656E7472696573207768657265206174747269627574652030332069732073657420746F20747275650D0A20202020666F72202820766172206920696E206C697374436F70792029207B0D0A20202020202069662028206C697374436F70795B695D2E45';
wwv_flow_api.g_varchar2_table(129) := '4E5452595F4154545249425554455F3033203D3D2022747275652229207B0D0A202020202020202072656D6F766564203D206C697374436F70792E73706C69636528692C2031293B0D0A2020202020202020617065782E64656275672E6D657373616765';
wwv_flow_api.g_varchar2_table(130) := '2820746869732E435F4C4F475F5741524E494E472C20746869732E6C6F675072656669782C20275F617065784372656174654D656E754A736F6E272C202772656D6F76696E6720656E7472792022272B72656D6F7665645B305D2E454E5452595F544558';
wwv_flow_api.g_varchar2_table(131) := '542B27222062656361757365206974732068696464656E2076696120413033272C2072656D6F766564293B0D0A2020202020207D0D0A202020207D0D0A2A2F202020200D0A0D0A20202020617065782E64656275672E6D6573736167652820746869732E';
wwv_flow_api.g_varchar2_table(132) := '435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E754A736F6E272C202763757272656E74206C697374272C20242E657874656E64285B5D2C206C697374436F707929293B0D0A0D0A202020';
wwv_flow_api.g_varchar2_table(133) := '206C697374436F7079203D206C697374436F70792E636F6E6361742820746869732E6578747261456E747269657320293B0D0A0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C2074686973';
wwv_flow_api.g_varchar2_table(134) := '2E6C6F675072656669782C20275F617065784372656174654D656E754A736F6E272C2027657874656E646564207769746820657874726120656E7472696573272C20242E657874656E64285B5D2C206C697374436F707929293B0D0A0D0A202020206C69';
wwv_flow_api.g_varchar2_table(135) := '7374436F70792E736F72742820746869732E5F736F727441727261792827736571272920293B0D0A0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C';
wwv_flow_api.g_varchar2_table(136) := '20275F617065784372656174654D656E754A736F6E272C2027736F72746564272C20242E657874656E64285B5D2C206C697374436F707929293B0D0A0D0A202020206D656E752E6974656D73203D20746869732E5F617065784372656174654D656E7545';
wwv_flow_api.g_varchar2_table(137) := '6E747269657328206C697374436F707920293B0D0A0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E754A73';
wwv_flow_api.g_varchar2_table(138) := '6F6E272C20276F7574206D656E75272C206D656E75293B0D0A0D0A2020202072657475726E206D656E753B0D0A20207D2C0D0A20205F617065784372656174654D656E75456E74726965733A2066756E6374696F6E2820704C69737420297B0D0A202020';
wwv_flow_api.g_varchar2_table(139) := '20617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C2020746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E747269657327293B0D0A20202020617065782E64656275672E';
wwv_flow_api.g_varchar2_table(140) := '6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E7472696573272C20704C697374293B0D0A202020200D0A20202020766172200D0A2020202020';
wwv_flow_api.g_varchar2_table(141) := '20656E74726965734172726179203D205B5D2C0D0A202020202020656E747279203D207B7D3B0D0A0D0A20202020666F7220282076617220693D303B2069203C20704C6973742E6C656E6774683B20692B2B20297B0D0A202020202020656E7472696573';
wwv_flow_api.g_varchar2_table(142) := '41727261792E707573682820746869732E5F617065784372656174654D656E75456E7472792820704C6973745B695D202920293B0D0A202020207D0D0A0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C45';
wwv_flow_api.g_varchar2_table(143) := '56454C362C2020746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E7472696573206F7574272C20656E74726965734172726179293B0D0A0D0A0D0A2020202072657475726E20656E747269657341727261793B0D0A20';
wwv_flow_api.g_varchar2_table(144) := '2020200D0A20207D2C0D0A20205F617065784765744D656E754974656D547970653A2066756E6374696F6E282070456E74727920297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C2074';
wwv_flow_api.g_varchar2_table(145) := '6869732E6C6F675072656669782C20275F617065784765744D656E754974656D54797065272C2070456E747279293B0D0A0D0A20202020696620282070456E7472792E454E5452595F4154545249425554455F3037203D3D2027736570617261746F7227';
wwv_flow_api.g_varchar2_table(146) := '2029207B0D0A20202020202072657475726E20746869732E435F454E5452595F545950455F534550415241544F523B0D0A202020207D0D0A20202020656C736520696620282070456E7472792E6974656D7320213D20756E646566696E65642029207B0D';
wwv_flow_api.g_varchar2_table(147) := '0A20202020202072657475726E20746869732E435F454E5452595F545950455F5355424D454E553B0D0A202020207D0D0A20202020656C7365207B0D0A20202020202072657475726E20746869732E435F454E5452595F545950455F414354494F4E3B0D';
wwv_flow_api.g_varchar2_table(148) := '0A202020207D0D0A20207D2C0D0A20205F617065784372656174654D656E75456E7472793A2066756E6374696F6E282070456E74727920297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C36';
wwv_flow_api.g_varchar2_table(149) := '2C20746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E7472792022272B70456E7472792E454E5452595F544558542B272227293B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C';
wwv_flow_api.g_varchar2_table(150) := '4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E747279272C2070456E747279293B0D0A0D0A0D0A202020202F2F6974656D730D0A20202020766172200D0A202020202020656E74727920';
wwv_flow_api.g_varchar2_table(151) := '3D207B7D2C0D0A20202020202074797065203D20746869732E5F617065784765744D656E754974656D54797065282070456E74727920293B200D0A0D0A20202020656E747279203D207B0D0A20202020202074797065202020202020203A20747970652C';
wwv_flow_api.g_varchar2_table(152) := '0D0A2020202020206C6162656C4B65792020203A2070456E7472792E454E5452595F544558542020202020202020203D3D20756E646566696E6564203F2070456E7472792E6C6162656C4B6579202020202020203A2070456E7472792E454E5452595F54';
wwv_flow_api.g_varchar2_table(153) := '4558542C0D0A2020202020206C6162656C2020202020203A2070456E7472792E454E5452595F544558542020202020202020203D3D20756E646566696E6564203F2070456E7472792E6C6162656C202020202020202020203A2070456E7472792E454E54';
wwv_flow_api.g_varchar2_table(154) := '52595F544558542C0D0A20202020202069636F6E202020202020203A2070456E7472792E454E5452595F494D41474520202020202020203D3D20756E646566696E6564203F2070456E7472792E69636F6E20202020202020202020203A2070456E747279';
wwv_flow_api.g_varchar2_table(155) := '2E454E5452595F494D4147452C0D0A20202020202069636F6E5374796C6520203A2070456E7472792E69636F6E5374796C652C0D0A202020202020616363656C657261746F723A2070456E7472792E454E5452595F4154545249425554455F3036203D3D';
wwv_flow_api.g_varchar2_table(156) := '20756E646566696E6564203F2070456E7472792E616363656C657261746F72202020203A2070456E7472792E454E5452595F4154545249425554455F30362C0D0A20202020202068726566202020202020203A2070456E7472792E454E5452595F544152';
wwv_flow_api.g_varchar2_table(157) := '474554202020202020203D3D20756E646566696E6564203F2070456E7472792E6872656620202020202020202020203A2070456E7472792E454E5452595F5441524745542C0D0A20202020202069642020202020202020203A2070456E7472792E454E54';
wwv_flow_api.g_varchar2_table(158) := '52595F4154545249425554455F3031203D3D20756E646566696E6564203F20756E646566696E6564202020202020202020202020203A2070456E7472792E454E5452595F4154545249425554455F30312C0D0A202020202020616374696F6E2020202020';
wwv_flow_api.g_varchar2_table(159) := '3A2070456E7472792E616374696F6E2C0D0A20202020202064697361626C65642020203A2070456E7472792E64697361626C65642C0D0A20202020202068696465202020202020203A2070456E7472792E686964650D0A202020207D3B0D0A0D0A202020';
wwv_flow_api.g_varchar2_table(160) := '20696620282074797065203D3D20746869732E435F454E5452595F545950455F5355424D454E552029207B0D0A202020202020656E7472792E6D656E75203D207B0D0A20202020202020202269636F6E54797065223A20226661222C0D0A202020202020';
wwv_flow_api.g_varchar2_table(161) := '2020226974656D73223A20746869732E5F617065784372656174654D656E75456E7472696573282070456E7472792E6974656D7320290D0A2020202020207D0D0A202020207D0D0A0D0A202020206966202820746869732E657874656E644A534F4E5B20';
wwv_flow_api.g_varchar2_table(162) := '656E7472792E6964205D20213D20756E646566696E65642029207B0D0A202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F6170657843726561';
wwv_flow_api.g_varchar2_table(163) := '74654D656E75456E74727920657874656E6420656E74727920616374696F6E272C2070456E747279293B0D0A0D0A202020202020656E7472792E616374696F6E203D20746869732E657874656E644A534F4E5B20656E7472792E6964205D2E616374696F';
wwv_flow_api.g_varchar2_table(164) := '6E3B0D0A0D0A2020202020202F2F64697361626C650D0A202020202020696620282070456E7472792E454E5452595F4154545249425554455F3032203D3D2022747275652220262620746869732E657874656E644A534F4E5B20656E7472792E6964205D';
wwv_flow_api.g_varchar2_table(165) := '2E64697361626C6564203D3D20756E646566696E656429207B0D0A2020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F6170657843726561';
wwv_flow_api.g_varchar2_table(166) := '74654D656E75456E7472792064697361626C6520656E747279206261736564206F6E20656E74727920617474726962757465283229206265636175736520657874656E64204A534F4E20646F65736E5C277420686176652064697361626C65642070726F';
wwv_flow_api.g_varchar2_table(167) := '7065727479272C2070456E747279293B0D0A2020202020202020656E7472792E64697361626C6564203D20747275653B0D0A2020202020207D200D0A202020202020656C7365206966202820746869732E657874656E644A534F4E5B20656E7472792E69';
wwv_flow_api.g_varchar2_table(168) := '64205D2E64697361626C656420213D20756E646566696E65642029207B0D0A2020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F61706578';
wwv_flow_api.g_varchar2_table(169) := '4372656174654D656E75456E7472792064697361626C65202F20656E61626C6520656E747279206261736564206F6E20656E7472792064697361626C652066756E6374696F6E20726573756C74272C2070456E747279293B0D0A2020202020202020656E';
wwv_flow_api.g_varchar2_table(170) := '7472792E64697361626C6564203D20746869732E657874656E644A534F4E5B20656E7472792E6964205D2E64697361626C65643B202020200D0A2020202020207D0D0A202020202020656C7365207B0D0A2020202020202020617065782E64656275672E';
wwv_flow_api.g_varchar2_table(171) := '6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E74727920656E747279206973206E6F742064697361626C6564272C2070456E747279293B0D0A';
wwv_flow_api.g_varchar2_table(172) := '2020202020202020656E7472792E64697361626C6564203D2066616C73653B0D0A2020202020207D200D0A0D0A2020202020202F2F686964650D0A202020202020696620282070456E7472792E454E5452595F4154545249425554455F3033203D3D2022';
wwv_flow_api.g_varchar2_table(173) := '747275652220262620746869732E657874656E644A534F4E5B20656E7472792E6964205D2E68696465203D3D20756E646566696E656429207B0D0A2020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C45';
wwv_flow_api.g_varchar2_table(174) := '56454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E747279206869646520656E747279206261736564206F6E20656E74727920617474726962757465283329206265636175736520657874656E64204A53';
wwv_flow_api.g_varchar2_table(175) := '4F4E20646F65736E5C2774206861766520686964652070726F7065727479272C2070456E747279293B0D0A2020202020202020656E7472792E68696465203D20747275653B0D0A2020202020207D200D0A202020202020656C7365206966202820746869';
wwv_flow_api.g_varchar2_table(176) := '732E657874656E644A534F4E5B20656E7472792E6964205D2E6869646520213D20756E646566696E65642029207B0D0A2020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E';
wwv_flow_api.g_varchar2_table(177) := '6C6F675072656669782C20275F617065784372656174654D656E75456E7472792068696465202F2073686F7720656E747279206261736564206F6E20656E74727920686964652066756E6374696F6E20726573756C74272C2070456E747279293B0D0A20';
wwv_flow_api.g_varchar2_table(178) := '20202020202020656E7472792E68696465203D20746869732E657874656E644A534F4E5B20656E7472792E6964205D2E686964653B202020200D0A2020202020207D0D0A202020202020656C7365207B0D0A2020202020202020617065782E6465627567';
wwv_flow_api.g_varchar2_table(179) := '2E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E74727920656E747279206973206E6F742068696464656E272C2070456E747279293B0D0A20';
wwv_flow_api.g_varchar2_table(180) := '20202020202020656E7472792E68696465203D2066616C73653B0D0A2020202020207D200D0A0D0A2020202020202F2F7375626D656E750D0A2020202020206966202820746869732E657874656E644A534F4E5B20656E7472792E6964205D2E6974656D';
wwv_flow_api.g_varchar2_table(181) := '7320213D20756E646566696E656420262620746869732E657874656E644A534F4E5B20656E7472792E6964205D2E6974656D732E6C656E677468203E20302029207B0D0A2020202020202020617065782E64656275672E6D657373616765282074686973';
wwv_flow_api.g_varchar2_table(182) := '2E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E74727920656E74727920686173207375626D656E752066726F6D20657874656E646564204A534F4E272C2070456E747279293B';
wwv_flow_api.g_varchar2_table(183) := '0D0A0D0A2020202020202020656E7472792E6D656E75203D207B0D0A202020202020202020202269636F6E54797065223A20226661222C0D0A20202020202020202020226974656D73223A20746869732E5F617065784372656174654D656E75456E7472';
wwv_flow_api.g_varchar2_table(184) := '6965732820746869732E657874656E644A534F4E5B20656E7472792E6964205D2E6974656D7320290D0A20202020202020207D0D0A0D0A20202020202020202F2F6368616E676520656E747279207479706520746F207375626D656E750D0A2020202020';
wwv_flow_api.g_varchar2_table(185) := '202020656E7472792E74797065203D20746869732E435F454E5452595F545950455F5355424D454E553B0D0A2020202020207D0D0A20200D0A202020207D0D0A20202020656C7365207B0D0A202020202020617065782E64656275672E6D657373616765';
wwv_flow_api.g_varchar2_table(186) := '2820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617065784372656174654D656E75456E74727920657874656E6420656E74727920616374696F6E272C2070456E747279293B0D0A0D0A20202020202069';
wwv_flow_api.g_varchar2_table(187) := '6620282070456E7472792E454E5452595F4154545249425554455F3032203D3D202274727565222029207B0D0A2020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F67';
wwv_flow_api.g_varchar2_table(188) := '5072656669782C20275F617065784372656174654D656E75456E7472792064697361626C6520656E747279206261736564206F6E20656E74727920617474726962757465283229272C2070456E747279293B0D0A2020202020202020656E7472792E6469';
wwv_flow_api.g_varchar2_table(189) := '7361626C6564203D20747275653B0D0A2020202020207D0D0A202020207D0D0A0D0A2020202072657475726E20656E7472793B0D0A20207D2C0D0A20200D0A20205F636F6E766572744F626A6563743A2066756E6374696F6E28297B0D0A202020206170';
wwv_flow_api.g_varchar2_table(190) := '65782E64656275672E6D6573736167652820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C20275F636F6E766572744F626A656374272C2027696E272C20242E657874656E64287B7D2C746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(191) := '2E6C6973742E656E747269657329293B0D0A0D0A20202020766172206E65774C697374203D205B5D3B0D0A0D0A20202020666F722028766172206920696E20746869732E6F7074696F6E732E6C6973742E656E747269657329207B0D0A2020202020206E';
wwv_flow_api.g_varchar2_table(192) := '65774C6973742E70757368287B0D0A2020202020202020454E5452595F494D41474520202020202020202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E494D4147452C0D0A2020202020202020454E';
wwv_flow_api.g_varchar2_table(193) := '5452595F544152474554202020202020202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E5441524745542C0D0A2020202020202020454E5452595F5445585420202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(194) := '20203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E4C4142454C2C0D0A2020202020202020454E5452595F494D4147455F415454524942555445532020202020203A20746869732E6F7074696F6E732E6C6973742E656E74';
wwv_flow_api.g_varchar2_table(195) := '726965735B695D2E494D4147455F4154545249425554452C0D0A2020202020202020454E5452595F494D4147455F414C545F4154545249425554452020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E494D4147455F41';
wwv_flow_api.g_varchar2_table(196) := '4C545F4154545249425554452C0D0A2020202020202020454E5452595F4154545249425554455F3031202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E415454524942555445312C0D0A2020202020';
wwv_flow_api.g_varchar2_table(197) := '202020454E5452595F4154545249425554455F3032202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E415454524942555445322C0D0A2020202020202020454E5452595F4154545249425554455F30';
wwv_flow_api.g_varchar2_table(198) := '33202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E415454524942555445332C0D0A2020202020202020454E5452595F4154545249425554455F3034202020202020202020203A20746869732E6F70';
wwv_flow_api.g_varchar2_table(199) := '74696F6E732E6C6973742E656E74726965735B695D2E415454524942555445342C0D0A2020202020202020454E5452595F4154545249425554455F3035202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B69';
wwv_flow_api.g_varchar2_table(200) := '5D2E415454524942555445352C0D0A2020202020202020454E5452595F4154545249425554455F3036202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E415454524942555445362C0D0A2020202020';
wwv_flow_api.g_varchar2_table(201) := '202020454E5452595F4154545249425554455F3037202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E415454524942555445372C0D0A2020202020202020454E5452595F4154545249425554455F30';
wwv_flow_api.g_varchar2_table(202) := '38202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B695D2E415454524942555445382C0D0A2020202020202020454E5452595F4154545249425554455F3039202020202020202020203A20746869732E6F70';
wwv_flow_api.g_varchar2_table(203) := '74696F6E732E6C6973742E656E74726965735B695D2E415454524942555445392C0D0A2020202020202020454E5452595F4154545249425554455F3130202020202020202020203A20746869732E6F7074696F6E732E6C6973742E656E74726965735B69';
wwv_flow_api.g_varchar2_table(204) := '5D2E41545452494255544531300D0A2020202020207D293B0D0A202020207D0D0A0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C20275F636F6E7665';
wwv_flow_api.g_varchar2_table(205) := '72744F626A656374272C20276F7574272C206E65774C697374293B0D0A0D0A2020202072657475726E206E65774C6973743B0D0A20207D2C0D0A20205F7072696E7446756E6374696F6E546F436F6E736F6C653A2066756E6374696F6E28207046756E63';
wwv_flow_api.g_varchar2_table(206) := '74696F6E426F647920297B0D0A20202020766172206172726179203D207046756E6374696F6E426F64792E73706C697428225C6E22293B0D0A20202020666F722028207661722069203D20303B2069203C2061727261792E6C656E6774683B20692B2B20';
wwv_flow_api.g_varchar2_table(207) := '29207B0D0A202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C202723272C2061727261795B695D293B0D0A202020207D0D0A20207D2C0D0A2F2F0D0A';
wwv_flow_api.g_varchar2_table(208) := '2F2F0D0A20205F7468726F774572726F723A2066756E6374696F6E2820705465787420297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C392C20746869732E6C6F675072656669782C207054';
wwv_flow_api.g_varchar2_table(209) := '657874293B200D0A0D0A20202020766172200D0A2020202020206D657373616765203D2070546578742C0D0A2020202020206D657373616765546578743B0D0A0D0A20202020666F72202876617220693D313B2069203C20617267756D656E74732E6C65';
wwv_flow_api.g_varchar2_table(210) := '6E6774683B20692B2B29207B0D0A2020202020206D657373616765203D206D6573736167652E7265706C616365282725272B28692D31292C20617267756D656E74735B695D293B0D0A202020207D0D0A0D0A202020206D65737361676554657874203D20';
wwv_flow_api.g_varchar2_table(211) := '6D6573736167653B0D0A0D0A202020206D657373616765203D2027272B0D0A202020202020273C7374726F6E673E272B746869732E435F504C5547494E5F4E414D452B273C2F7374726F6E673E3C62723E272B0D0A2020202020202F2F746869732E6461';
wwv_flow_api.g_varchar2_table(212) := '4E616D652B273C62723E272B0D0A202020202020273C7370616E20636C6173733D2270726574697573617065786D656E756C6973742D6572726F724D657373616765223E272B6D6573736167652B273C2F7370616E3E273B202020200D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(213) := '617065782E6D6573736167652E636C6561724572726F727328293B0D0A0D0A20202020617065782E6D6573736167652E73686F774572726F727328207B0D0A202020202020747970653A20617065782E6D6573736167652E4552524F522C0D0A20202020';
wwv_flow_api.g_varchar2_table(214) := '20206C6F636174696F6E3A202270616765222C0D0A2020202020206D6573736167653A206D6573736167650D0A202020207D20293B0D0A0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4552524F522C2074';
wwv_flow_api.g_varchar2_table(215) := '6869732E6C6F675072656669782C206D65737361676554657874293B200D0A0D0A20202020746869732E64657374726F7928293B0D0A202020207468726F772027506C7567696E2073746F7070656421273B0D0A20207D2C0D0A20200D0A20205F617474';
wwv_flow_api.g_varchar2_table(216) := '724F766572726964654265686176696F75723A2066756E6374696F6E28297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F617474724669';
wwv_flow_api.g_varchar2_table(217) := '78506F736974696F6E27293B0D0A0D0A2020202072657475726E20746869732E6F7074696F6E732E616374696F6E2E61747472696275746530322E696E6465784F6628274F4D422729203E202D313B0D0A20207D2C0D0A20205F61747472466978506F73';
wwv_flow_api.g_varchar2_table(218) := '6974696F6E3A2066756E6374696F6E28297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F61747472466978506F736974696F6E27293B0D';
wwv_flow_api.g_varchar2_table(219) := '0A0D0A2020202072657475726E20746869732E6F7074696F6E732E616374696F6E2E61747472696275746530322E696E6465784F66282746502729203E202D313B0D0A20207D2C0D0A20205F617474724164644578747261456E74726965733A2066756E';
wwv_flow_api.g_varchar2_table(220) := '6374696F6E28297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F61747472446973706C617941744D6F757365506F736974696F6E27293B';
wwv_flow_api.g_varchar2_table(221) := '0D0A0D0A2020202072657475726E20746869732E6F7074696F6E732E616374696F6E2E61747472696275746530322E696E6465784F66282745452729203E202D313B0D0A20207D2C0D0A20205F61747472446973706C617941744D6F757365506F736974';
wwv_flow_api.g_varchar2_table(222) := '696F6E3A2066756E6374696F6E28297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C20275F61747472446973706C617941744D6F757365506F73';
wwv_flow_api.g_varchar2_table(223) := '6974696F6E27293B0D0A0D0A2020202072657475726E20746869732E6F7074696F6E732E616374696F6E2E61747472696275746530322E696E6465784F66282744414D502729203E202D313B0D0A20207D2C0D0A202067657444656275674F626A656374';
wwv_flow_api.g_varchar2_table(224) := '3A2066756E6374696F6E28297B0D0A20202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C202767657444656275674F626A65637427293B0D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(225) := '72657475726E207B0D0A20202020202022656C656D656E74223A20746869732E656C656D656E742E6765742830292C0D0A202020202020226F7074696F6E73223A20242E657874656E64287B7D2C20746869732E6F7074696F6E73292C0D0A2020202020';
wwv_flow_api.g_varchar2_table(226) := '2022776964676574223A20242E657874656E64287B7D2C2074686973290D0A202020207D3B0D0A20207D2C0D0A202073686F773A2066756E6374696F6E2820704576656E742C2070466F72636520297B0D0A20202020617065782E64656275672E6D6573';
wwv_flow_api.g_varchar2_table(227) := '736167652820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C202773686F77272C20746869732E67657444656275674F626A6563742829293B200D0A20202020617065782E64656275672E6D65737361676528207468';
wwv_flow_api.g_varchar2_table(228) := '69732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C202773686F77206576656E74272C20704576656E74293B200D0A0D0A2020202076617220782C20793B0D0A0D0A202020206966202820746869732E656C656D656E742E69';
wwv_flow_api.g_varchar2_table(229) := '732827627574746F6E272920262620746869732E6F7074696F6E732E6973436F6E746578744D656E75203D3D2066616C73652026262070466F726365203D3D20756E646566696E6564297B0D0A202020202020617065782E64656275672E6D6573736167';
wwv_flow_api.g_varchar2_table(230) := '652820746869732E435F4C4F475F44454255472C20746869732E6C6F675072656669782C202773686F773A20656C656D656E7420697320627574746F6E2C206C657420617065782068616E646C652073686F77696E67206D656E7520697473656C662E27';
wwv_flow_api.g_varchar2_table(231) := '293B200D0A20202020202072657475726E20766F69642830293B0D0A202020207D0D0A0D0A202020206966202820746869732E697356697369626C652029207B0D0A202020202020617065782E64656275672E6D6573736167652820746869732E435F4C';
wwv_flow_api.g_varchar2_table(232) := '4F475F5741524E494E472C20746869732E6C6F675072656669782C202773686F773A206D656E752069732076697369626C652C20646F6E5C27742073686F7720697420616761696E2127293B0D0A20202020202072657475726E20766F69642830293B0D';
wwv_flow_api.g_varchar2_table(233) := '0A202020207D0D0A0D0A2020202078203D20704576656E742E70616765583B0D0A2020202079203D20704576656E742E70616765593B0D0A0D0A202020206966202820746869732E5F61747472446973706C617941744D6F757365506F736974696F6E28';
wwv_flow_api.g_varchar2_table(234) := '292029207B0D0A202020202020696620282078203D3D20302026262079203D3D20302029207B0D0A2020202020202020617065782E64656275672E6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669';
wwv_flow_api.g_varchar2_table(235) := '782C20276D656E7520776173206D656E7420746F20646973706C617920617420706F736974696F6E20783D22302220262620793D2230222E204D656E7520697320616C69676E656420746F2074726967676572696E6720656C656D656E742E27293B0D0A';
wwv_flow_api.g_varchar2_table(236) := '2020202020202020746869732E6D656E75436F6E7461696E65722E6D656E7528226F70656E222C20746869732E656C656D656E74293B0D0A0D0A2020202020207D0D0A202020202020656C7365207B0D0A2020202020202020617065782E64656275672E';
wwv_flow_api.g_varchar2_table(237) := '6D6573736167652820746869732E435F4C4F475F4C4556454C362C20746869732E6C6F675072656669782C202773686F7720617420706F736974696F6E20783D22272B782B27222C20793D22272B792B272227293B0D0A2020202020202020746869732E';
wwv_flow_api.g_varchar2_table(238) := '6D656E75436F6E7461696E65722E6D656E7528226F70656E222C20782C2079293B0D0A2020202020207D0D0A202020207D0D0A20202020656C7365207B0D0A202020202020746869732E6D656E75436F6E7461696E65722E6D656E7528226F70656E222C';
wwv_flow_api.g_varchar2_table(239) := '20746869732E656C656D656E74293B0D0A202020207D0D0A20207D2C0D0A20206465626F756E63653A2066756E6374696F6E2866756E632C20776169742C20696D6D65646961746529207B0D0A202020202F2F617065782E64656275672E6C6F67282764';
wwv_flow_api.g_varchar2_table(240) := '65626F756E6365272C202766756E63272C2066756E632C202777616974272C20776169742C2027696D6D656469617465272C20696D6D656469617465293B0D0A0D0A202020207661722074696D656F75743B0D0A2020202072657475726E2066756E6374';
wwv_flow_api.g_varchar2_table(241) := '696F6E2829207B0D0A20202020202076617220636F6E74657874203D20746869732C2061726773203D20617267756D656E74733B0D0A202020202020766172206C61746572203D2066756E6374696F6E2829207B0D0A202020202020202074696D656F75';
wwv_flow_api.g_varchar2_table(242) := '74203D206E756C6C3B0D0A20202020202020206966202821696D6D656469617465292066756E632E6170706C7928636F6E746578742C2061726773293B0D0A2020202020207D3B0D0A2020202020207661722063616C6C4E6F77203D20696D6D65646961';
wwv_flow_api.g_varchar2_table(243) := '7465202626202174696D656F75743B0D0A202020202020636C65617254696D656F75742874696D656F7574293B0D0A20202020202074696D656F7574203D2073657454696D656F7574286C617465722C2077616974293B0D0A2020202020206966202863';
wwv_flow_api.g_varchar2_table(244) := '616C6C4E6F77292066756E632E6170706C7928636F6E746578742C2061726773293B0D0A202020207D3B0D0A20207D2C0D0A20207468726F74746C653A2066756E6374696F6E2863616C6C6261636B2C206C696D697429207B0D0A202020207661722077';
wwv_flow_api.g_varchar2_table(245) := '616974203D2066616C73653B2020202020202020202020202020202020202F2F20496E697469616C6C792C207765277265206E6F742077616974696E670D0A2020202072657475726E2066756E6374696F6E202829207B20202020202020202020202020';
wwv_flow_api.g_varchar2_table(246) := '20202F2F2057652072657475726E2061207468726F74746C65642066756E6374696F6E0D0A202020202020202069662028217761697429207B202020202020202020202020202020202020202F2F204966207765277265206E6F742077616974696E670D';
wwv_flow_api.g_varchar2_table(247) := '0A20202020202020202020202063616C6C6261636B2E63616C6C28293B20202020202020202020202F2F20457865637574652075736572732066756E6374696F6E0D0A20202020202020202020202077616974203D20747275653B202020202020202020';
wwv_flow_api.g_varchar2_table(248) := '2020202020202F2F2050726576656E742066757475726520696E766F636174696F6E730D0A20202020202020202020202073657454696D656F75742866756E6374696F6E202829207B2020202F2F204166746572206120706572696F64206F662074696D';
wwv_flow_api.g_varchar2_table(249) := '650D0A2020202020202020202020202020202077616974203D2066616C73653B202020202020202020202F2F20416E6420616C6C6F772066757475726520696E766F636174696F6E730D0A2020202020202020202020207D2C206C696D6974293B0D0A20';
wwv_flow_api.g_varchar2_table(250) := '202020202020207D0D0A202020207D0D0A20207D0D0A7D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(287527547165408580)
,p_plugin_id=>wwv_flow_api.id(267205648688277419)
,p_file_name=>'pretius.apexListMenu.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
