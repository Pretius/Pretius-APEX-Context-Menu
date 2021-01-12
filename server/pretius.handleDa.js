function pretius_handle_da( pJson ) {
  return $.extend( this, {
    "orgThis"                       : $.extend({}, this),
    "logPrefix"                     : '# '+this.action.action,
    "eventInternalName"             : pJson.da.WHEN_EVENT_INTERNAL_NAME,
    "eventCustomName"               : pJson.da.WHEN_EVENT_CUSTOM_NAME,
    "daName"                        : pJson.da.DYNAMIC_ACTION_NAME,
    "dynamicActionScope"            : pJson.da.WHEN_EVENT_SCOPE,
    "type"                          : pJson.type,
    "entries"                       : pJson.entries,
    "attrNarrowToAffectedElements"  : this.action.attribute02.indexOf('NTAE') > -1,
    "attrStopeEventPropagation"     : this.action.attribute02.indexOf('SEP') > -1,
    "getListenToEvent": function( pDestElements ){
      var click = 'click';

      if ( this.eventInternalName == 'ready' && pDestElements.filter('button').length == 0 ) {
        return click;
      }
      else if ( this.eventInternalName == 'apexafterrefresh' && pDestElements.filter('button').length == 0 ) {
        return click;
      }

      return null;
    },
    "getExtraOptions": function( pDestElements ){
      return {
        "dynamicActionScope": this.dynamicActionScope,
        "isContextMenu"     : this.eventInternalName == 'custom' && this.eventCustomName == 'contextmenu' ? true : false,
        "listenToEvent"     : this.getListenToEvent( pDestElements )
      }
    },
    "throwError": function( pErrorMessage, pStopExecution ){
      apex.debug.message( apex.debug.LOG_LEVEL.ERROR , pErrorMessage);

      var message = ''+
        '<strong>Pretius APEX Context Menu</strong><br>'+
        //this.daName+'<br>'+
        '<span class="pretiusapexmenulist-errorMessage">'+pErrorMessage+'</span>';

      apex.message.clearErrors();

      apex.message.showErrors( {
        type: apex.message.ERROR,
        location: "page",
        message: message
      } );

      if ( pStopExecution ) {
        throw "Dynamic action stopped!";
      }

    },
    "getNarrowedAffectedElements": function( pNarrowToEventTarget ){
      var 
        narrowed,
        eventTarget = this.browserEvent.target;
        triggeringElement = this.triggeringElement;

      narrowed = $.grep(this.affectedElements, function(pElement) {
        if ( $.contains(triggeringElement, pElement) || triggeringElement == pElement) {
          return true;
        }
        else {
          return false;
        }
      });

      if ( pNarrowToEventTarget ) {
        narrowed = $.grep(narrowed, function(pElement) {
          if ( $.contains(pElement, eventTarget) ) {
            return true;
          }
          else if ( pElement == eventTarget ) {
            return true;
          }
          else {
            return false;
          }
        });

      }

      return narrowed;
    },
    "checkDaImplementation": function(){
      if ( this.action.affectedElementsType == null && this.eventInternalName == 'ready' ) {
        return 'Invalid Dynamic Action configuration: Page Load event requires affected elements to be defined.';
      }
      
      else if ( this.action.affectedElementsType == null && this.eventInternalName == 'apexafterrefresh' ) {
        return 'Invalid Dynamic Action configuration: After Refresh event requires affected elements to be defined.'; 
      }
      
      else if ( this.action.affectedElementsType == null && this.attrNarrowToAffectedElements) {
        return 'Invalid Dynamic Action configuration: attribute "Narrow to affected elements" is checked but "affected elements" is not set.';
      }
      
      else if ( 
        this.eventInternalName == 'custom' && this.eventCustomName != 'contextmenu' 
        && this.attrNarrowToAffectedElements && this.action.affectedElementsType == null
      ) {
        return 'Invalid Custom Event Configuration: attribute "Narrow to affected elements" is checked but "affected elements" is not set.';
      }
      else if (
        this.eventInternalName == 'custom' && this.eventCustomName != 'contextmenu' 
        && this.attrNarrowToAffectedElements == false 
        && this.data == undefined
      ) {
        return 'Invalid Custom Event Configuration: this.data is undefined.' ;
      }

      else if (
        this.eventInternalName == 'custom' && this.eventCustomName != 'contextmenu' 
        && this.attrNarrowToAffectedElements == false 
        && this.data.element == undefined
      ) {
        return 'Invalid Custom Event Configuration: this.data.element is undefined.'
      }      

      else if ( $.inArray( this.eventInternalName, ['click', 'ready', 'custom', 'apexafterrefresh'] ) == -1 ) {
        return 'Not supported Dynamic Action event: "'+this.eventInternalName+'".';
      }

      //possible errors not raised, return true;

      return true;
    },
    "getDestElements": function(){
      if ( this.eventInternalName == 'click' ) {
        return this.attrNarrowToAffectedElements ? this.getNarrowedAffectedElements() : this.triggeringElement;
      }

      else if ( this.eventInternalName == 'custom' && this.eventCustomName == 'contextmenu' ) {
        return this.attrNarrowToAffectedElements ? this.getNarrowedAffectedElements( true ) : this.triggeringElement;
      }

      else if ( this.eventInternalName == 'custom' && this.eventCustomName != 'contextmenu' ) {

        if ( this.attrNarrowToAffectedElements ) {
          return this.affectedElements;
        }
        else {
          return this.data.element;
        }
      }

      else if ( this.eventInternalName == 'ready' ) {
        return this.affectedElements;
      }

      else if ( this.eventInternalName == 'apexafterrefresh' ) {
        return this.attrNarrowToAffectedElements ? this.getNarrowedAffectedElements() : this.affectedElements;
      }

      else {
        //other event not supported
        //normally function checkDaImplementation will raise error
        //raise error?
        return this.triggeringElement;
      }
    },
    "init": function(){
      var 
        destElements = undefined,
        isDaConfigured,
        widgetOptions;

      //check if dynamic action is configured properly
      isDaConfigured = this.checkDaImplementation();

      if ( typeof isDaConfigured == 'string') {
        this.throwError( isDaConfigured, true );
        return void(0);
      }

      //get dest element based on event type, triggering element, affected elements and plugin attribute "Narrow to affected elements"
      destElements = $( this.getDestElements() );

      if ( destElements.length == 0 ) {
        apex.debug.message( apex.debug.LOG_LEVEL.WARN , this.logPrefix, 'Dynamic action "'+this.daName+'" stopped: no elements found!');
        return void(0);
      }
      else {
        apex.debug.message( apex.debug.LOG_LEVEL.INFO , this.logPrefix, 'Create context menu for dynamic action "'+this.daName+'"', destElements);
      }

      //check mixed types
      if ( destElements.filter('button').length > 0 && destElements.filter('button').length != destElements.length ) {
        //mixed types (button & other) is not supported
        this.throwError( 'Invalid Dynamic Action configuration: affected elements returning buttons and other HTML DOM elements are not supported.' , true );
        return void(0);
      }


      if ( this.attrStopeEventPropagation ) {
        this.browserEvent.preventDefault();
        this.browserEvent.stopImmediatePropagation();
        apex.debug.message( apex.debug.LOG_LEVEL.APP_TRACE , this.logPrefix, 'Event propagation prevented.');
      }
      else {
        apex.debug.message( apex.debug.LOG_LEVEL.WARN , this.logPrefix, 'Event is propagated up DOM tree.');
      }

      list =  {
        "list": {
          type: this.type,
          entries: this.entries
        }
      };

      widgetOptions = $.extend({}, this.orgThis, list, this.getExtraOptions( destElements ) )

      //tbd
      //destElements.each()!
      if ( destElements.data('pretius-apexListMenu') == undefined ) {
        
        if ( this.data != undefined && this.data.options != undefined ) {
          //in case of custom event with this.data set (element and options) override default attributes
          destElements.apexListMenu($.extend(widgetOptions, this.data.options) );  
        }
        else {
          destElements.apexListMenu(widgetOptions );
        }
      }
      else {
        destElements.apexListMenu('show', this.browserEvent);
      }

      return void(0);   
    }
  });
}