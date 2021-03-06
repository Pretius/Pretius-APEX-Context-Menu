# Pretius APEX Context Menu

Pretius APEX Context Menu is dynamic action plugin implementing APEX popup menu based on defined APEX list. The plugin can be attached to any HTML element and renders entries according to authorisation scheme result. Menu entries can be extended by overriding behaviour, dynamically adding submenu and by adding new entries.

## Preview

![Preview gif](images/image_preview.gif)

## Table of Contents 

- [License](#license)
- [Demo application](#demo-application)
- [Features at Glance](#features-at-glance)
- [Roadmap](#roadmap)
- [Install](#install)
    - [Installation package](#installation-package)
    - [Install procedure](#install-procedure)
- [APEX list integration](#apex-list-integration)
    - [Conditions](#conditions)
    - [Authorization schemes](#authorization-schemes)
    - [User defined attributes for list entry](#user-defined-attributes-for-list-entry)
- [Usage Guide](#usage-guide)
    - [Basic usage](#basic-usage)
    - [Advanced usage](#advanced-usage)
- [Plugin Settings](#plugin-settings)
    - [Plugin Events](#plugin-events)
    - [Translations](#translations)
- [Changelog](#changelog)
    - [1.0.0](#100)
    - [1.1.0](#110)
- [Known issues](#known-issues)
- [Related articles](#related-articles)
- [About Author](#about-author)
- [About Pretius](#about-pretius)
- [Free support](#free-support)
  - [Bug reporting and change requests](#bug-reporting-and-change-requests)
  - [Implementation issues](#implementation-issues)
- [Become a contributor](#become-a-contributor)
- [Comercial support](#comercial-support)

## License

MIT

## Demo application

[https://apex.oracle.com/pls/apex/f?p=PRETIUS_APEX_CONTEXT_MENU:1](https://apex.oracle.com/pls/apex/f?p=PRETIUS_APEX_CONTEXT_MENU:1)

## Features at Glance

* compatible with Oracle APEX 5.1, 18.x, 19.x
* basic usage doesn't require JavaScript knowledge
* [uses native APEX menu widget](https://docs.oracle.com/database/apex-18.1/AEXJS/menu.html)
* based on APEX list
  * supports authorization schemes
  * supports basic conditions
* list entries can be extended on runtime
    * to override action on click
    * to disable entry
    * to hide entry
    * to add submenu defined outside APEX list
* can be bind with any DOM element

## Roadmap
* not yet available

## Install

### Installation package
* `PRETIUS_APEX_CONTEXT_MENU.sql` - the plugin package specification
* `PRETIUS_APEX_CONTEXT_MENU.plb` - the plugin package body
* `dynamic_action_plugin_com_pretius_apex_contextmenu.sql` - the plugin installation file for Oracle APEX 5.1 or higher

### Install procedure
To successfully install the plugin follow those steps:
1. Install package `PRETIUS_APEX_CONTEXT_MENU` in Oracle APEX Schema
1. Install the plugin file `dynamic_action_plugin_com_pretius_apex_contextmenu.sql`

## APEX list integration

### Conditions

The plugin checks entry defined conditions. For conditions types

* PLSQL_EXPRESION
* PLSQL_EXPRESSION
* FUNC_BODY_RETURNING_BOOLEAN
* EXISTS
* NOT_EXISTS
* NEVER

result is evaluated and if condition is not met then entry is not rendered. If entry condition is other type than listed above then entry is not rendered.

### Authorization schemes

The plugin checks entry defined authorization scheme. If current result is `true` then entry is rendered. 

### User defined attributes for list entry

The plugin uses **user defined attributes** to change behaviour of the list entry. See table below

Property     | Description
-------------|------------
Attribute 01 | id used to identify entry
Attribute 02 | when set to `true` then entry is disabled
Attribute 03 | when set to `true` then entry is not rendered
Attribute 04 | reserved by APEX navigation template to set title. Not working (?)
Attribute 05 | reserved by APEX navigation template to set shortcut (?). Not working (?)
Attribute 06 | provided text is used as accelerator text displayed right to entry label.
Attribute 07 | when set to `separator` then display as horizontal separator
Attribute 08 | not used
Attribute 09 | not used
Attribute 10 | not used


## Usage Guide

### Basic usage

1. Create APEX List `POPUP_MENU`
1. Create entries and define according to your needs (authorisation scheme, action etc)
1. Create new button `BTN_POPUP_MENU`
1. Create dynamic action
    1. Set `Event` to `Click`
    1. Set `Selection Type` to `Button`
    1. Set `Button` to `BTN_POPUP_MENU`
    1. Set `Advanced \ Event Scope` to `Dynamic`
    1. Set `Advanced \ Static Container (jQuery Selector)` to `body`
1. Create `True` action
    1. Set `Action` to `Pretius APEX Context Menu [Plug-In]`
    1. Set `List name` to `POPUP_MENU`
1. Save & run page

Clicking the button `BTN_POPUP_MENU` will create popup menu.

### Contextual menu

The plugin can be implemented to alter default context menu (right mouse button click).

1. Create APEX List `POPUP_MENU`
1. Create entries and define according to your needs (authorisation scheme, action etc)
1. Create dynamic action
    1. Set `Event` to `Custom`
    1. Set `Custom Event` to `contextmenu`
    1. Set `Selection Type` to `JavaScript Expression`
    1. Set `JavaScript Expression` to `document`
    1. Set `Advanced \ Event Scope` to `Dynamic`
    1. Set `Advanced \ Static Container (jQuery Selector)` to `body`    
1. Create `True` action
    1. Set `Action` to `Pretius APEX Context Menu [Plug-In]`
    1. Set `List name` to `POPUP_MENU`
    1. _[Optional]_ Set `Affected Elements` to narrow area in which context menu will be available. For example region.
1. Save & run page

Contextual menu can be applied to any element by specyfing `Selection Type` = `jQuery Selector`. Contextual menu can be positioned differently:

* when `Selection Type` = `JavaScript Expression` and `JavaScript Expression` = `document` then menu is positioned to right click event position properties `event.pageX` and `event.pageY`
    * when `Affected Elements` is defined then menu is available only for area defined by given `Affected Elements`
* When `Selection Type` = `jQuery Selector` then menu is positioned to given `jQuery Selector`

### Advanced usage

Please read inline help text for attribute `Override Behaviour` for detailed information about JSON object extending existing list entry. 

1. Create APEX List `POPUP_MENU_EXTEND`
1. Create entry 
    1. Set `List Entry Label` to `Extended behaviour`
    1. Set `Target type` to `URL`
    1. Set `URL Target` to `javascript: void(0);`
    1. Set `User defined Attribute 1` to `EXTENDED_BEHAVIOUR`
1. Create new button `BTN_POPUP_MENU_EXTEND`
1. Create dynamic action
    1. Set `Event` to `Click`
    1. Set `Selection Type` to `Button`
    1. Set `Button` to `BTN_POPUP_MENU_EXTEND`
1. Create `True` action
    1. Set `Action` to `Pretius APEX Context Menu [Plug-In]`
    1. Set `List name` to `POPUP_MENU_EXTEND`
    1. In `Settings` check `Override Behaviour`
    1. Set `Override behaviour` to `*`
1. Save & run page

#### Alter entry behaviour

`*` JavaScript code for point 5.iv
```javascript
return {
  "EXTENDED_BEHAVIOUR": {
    "action": function( pMenuOptions, pTriggeringElement ){
      //Code to be executed when users clicks on entry
      alert('Altered action');
      return void(0);
    },
    "disabled": function( pMenuOptions, pEntry ) {
      return false;
    },
    "hide": function(pMenuOptions){
      return false;
    }
  }
};
```

#### Add submenu

`*` JavaScript code for point 5.iv
```javascript
return {
  "EXTENDED_BEHAVIOUR": {
    "items": [
      {
        "type": "action",
        "labelKey": "Action 1",
        "action": function( pMenuOptions, pTriggeringElement ){
          alert("Action 1");
        }
      },
      {
        "type": "action",
        "labelKey": "Action 2",
        "action": function( pMenuOptions, pTriggeringElement ){
          alert("Action 2");
        }
      },
      {
        "type": "action",
        "labelKey": "Action 3",
        "action": function( pMenuOptions, pTriggeringElement ){
          alert("Action 3");
        }
      }
    ]
  }
};
```

List entry properties for APEX menu widget are described in [official API](https://docs.oracle.com/database/apex-18.1/AEXJS/menu.html#.Item). The plugin supports properties as follows:

Property              | Is supported
----------------------|-------------
**type**              | **Yes**
**id**                | **Yes**
**label**             | **Yes**
**labelKey**          | **Yes**
offLabel              | No
offLabelKey           | No
onLabel               | No
onLabelKey            | No
**hide**              | **Yes**
**disabled**          | **Yes**
iconType              | No
**icon**              | **Yes**
**iconStyle**         | **Yes**
**href**              | **Yes**
**action**            | **Yes**
set                   | No
get                   | No
**accelerator**       | **Yes**
menu*                 | No
choices               | No
choices[].label       | No
choices[].labelKey    | No
choices[].value       | No
choices[].disabled    | No
choices[].accelerator | No
current               | No

`*` menu property is implemented via property `items` to avoid unnecessary nested objects. See `Inline Help Text` for attribute `Override behaviour` for example implmentation.

## Plugin Settings

Detailed information about how to use every attribute of the plugin is presented in built-in help texts in APEX Application Builder.

![Helptexts gif](images/image_helptexts.gif)

### Plugin Events

The plugin doesn't expose any extra events. To handle APEX menu events please refer [official API](https://docs.oracle.com/database/apex-18.1/AEXJS/menu.html#events-section).

### Translations

The plugin does't use elements that can't be translated via APEX native translation capabilities.

## Changelog

### 1.1.0

Changelog for version v1.1.0 is described in details in this [blog post](https://www.ostrowskibartosz.pl/archiwa/692)

* support for accessibility,
* `Plugin` attribute settings has new been enhanced with new options to select,
  * **Display at Mouse Position**
  * **Narrow to Affected Elements**
  * **Stop Event Propagation**
* `JavaScript` attributes **Override Behaviour** and **Add Extra Enties**,
  * have extended access to dynamic actions attributes
    * this.action -  the action object containing details such as the action name and additional attribute values,
    * this.browserEvent - the event object of event that triggered the event [3],
    * this.data -  optional additional data that can be passed from the event handler,
  * have extended access to the plugin widget attributes  
    * this.element -  a jQuery reference to the DOM object of the element that invoked a menu, 
    * this.id -  unique identifier generated by the plugin to identify a menu container.  
* `Plugin` debugging supports all levels: **LOG**, **LEVEL6** and **APP_TRACE**,
* `Plugin` error handling is more descriptive.

### 1.0.0 
Initial Release

## Known issues

* not yet available

## Related articles
* [Open modal page using Pretius APEX Context Menu](https://www.ostrowskibartosz.pl/2019/12/open-modal-page-using-pretius-apex-context-menu/)
* [Pretius APEX Enhanced LOV Item v1.1.0 supports Interactive Grid!](https://www.ostrowskibartosz.pl/2019/12/pretius-apex-enhanced-lov-item-v1-1-0-interactive-grid/)
* [APEX item Quick Picks as Context Menu](https://www.ostrowskibartosz.pl/2019/10/apex-item-quick-picks-as-context-menu/)
* [Pretius Context Menu  v1.1.0 in details](https://www.ostrowskibartosz.pl/2019/10/pretius-context-menu-release-v1-1-0/)
* [Report checkbox menu aka Google Gmail](https://www.ostrowskibartosz.pl/2019/09/report-checkbox-menu-aka-google-gmail/)
* [Context Menu in Oracle APEX](https://www.ostrowskibartosz.pl/2019/08/context-menu-in-oracle-apex/)

## About Author
Author | Website |Github | Twitter | E-mail
-------|---------|-------|---------|-------
Bartosz Ostrowski | [www.ostrowskibartosz.pl](http://www.ostrowskibartosz.pl) | [@bostrowski](https://github.com/bostrowski) | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com

## About Pretius
Pretius Sp. z o.o. Sp. K.

Address | Website | E-mail
--------|---------|-------
Przy Parku 2/2 Warsaw 02-384, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)

## Free support
Pretius provides free support for the plugins at the GitHub platform. 
We monitor raised issues, prepare fixes, and answer your questions. However, please note that we deliver the plug-ins free of charge, and therefore we will not always be able to help you immediately. 

Interested in better support? 
* [Become a contributor!](#become-a-contributor) We always prioritize the issues raised by our contributors and fix them for free.
* [Consider comercial support.](#comercial-support) Options and benefits are described in the chapter below.


### Bug reporting and change requests
Have you found a bug or have an idea of additional features that the plugin could cover? Firstly, please check the Roadmap and Known issues sections. If your case is not on the lists, please open an issue on a GitHub page following these rules:
* issue should contain login credentials to the application at apex.oracle.com where the problem is reproduced;
* issue should include steps to reproduce the case in the demo application;
* issue should contain description about its nature.

### Implementation issues
If you encounter a problem during the plug-in implementation, please check out our demo application. We do our best to describe each possible use case precisely. If you can not find a solution or your problem is different, contact us: apex-plugins@pretius.com.

## Become a contributor!
We consider our plugins as genuine open source products, and we encourage you to become a contributor. Help us improve plugins by fixing bugs and developing extra features. Comment one of the opened issues or register a new one, to let others know what you are working on. When you finish, create a new pull request. We will review your code and add the changes to the repository.

By contributing to this repository, you help to build a strong APEX community. We will prioritize any issues raised by you in this and any other plugins.

## Comercial support
We are happy to share our experience for free, but we also realize that sometimes response time, quick implementation, SLA, and instant release for the latest version are crucial. That’s why if you need extended support for our plug-ins, please contact us at apex-plugins@pretius.com.
We offer:
* enterprise-level assistance;
* support in plug-ins implementation and utilization;
* dedicated contact channel to our developers;
* SLA at the level your organization require;
* priority update to next APEX releases and features listed in the roadmap.