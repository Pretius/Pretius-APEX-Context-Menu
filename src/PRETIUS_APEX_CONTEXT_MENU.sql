create or replace package PRETIUS_APEX_CONTEXT_MENU_V110 as

  function render (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin 
  ) return apex_plugin.t_dynamic_action_render_result;

end PRETIUS_APEX_CONTEXT_MENU_V110;
