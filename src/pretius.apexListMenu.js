$.widget('pretius.apexListMenu', {
//
  C_ERR_MSG_EXTRA_RETURN_UNDEFINED : 'Extra Entries returned undefined.',
  C_ERR_MSG_EXTRA_RETURN_INVALID   : 'Extra Entries returned invalid object.',
  C_ERR_MSG_EXTRA_EXECUTE_JS       : 'Extra Entries raised error "%0".',

  C_ERR_MSG_EXTEND_EXECUTE_JS      : 'Override Behaviour raised error: "%0".',
  C_ERR_MSG_EXTEND_RETURN_INVALID  : 'Override Behaviour returned invalid object.',
//
  C_LOG_DEBUG    : apex.debug.LOG_LEVEL.INFO,
  C_LOG_WARNING  : apex.debug.LOG_LEVEL.WARN,
  C_LOG_ERROR    : apex.debug.LOG_LEVEL.ERROR,
  C_LOG_LEVEL6   : apex.debug.LOG_LEVEL.APP_TRACE,
  C_LOG_LEVEL9   : apex.debug.LOG_LEVEL.ENGINE_TRACE,

  C_ENTRY_TYPE_ACTION    : 'action',
  C_ENTRY_TYPE_SUBMENU   : 'subMenu',
  C_ENTRY_TYPE_SEPARATOR : 'separator',

  C_PLUGIN_NAME : 'Pretius APEX Context Menu',

  _create: function(){
    this._super( this.options );

    this.logPrefix = '# '+this.options.action.action;

    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_create', this.getDebugObject());

    if ( this.options.list.type == 'SQL_QUERY' || this.options.list.type == 'FUNCTION_RETURNING_SQL_QUERY' )  {
      apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_create', 'convert dynamic list query result');
      this.options.list.entries = this._convertObject();
    }

    this.isVisible = false;

    this.uniqueId  = $('<div></div>').uniqueId().attr('id');
    this.eventNameSpace   = this.options.action.action+'-'+this.uniqueId;

    if ( this.element != document ) {
      this.element
        .attr({
          "data-menu": this.uniqueId,
          "aria-haspopup": true,
          "aria-expanded": false
        })
        .addClass('js-menuButton');
    }

    this.menuContainer = this._createMenuContainer();
    this.menuContainer.appendTo("body");    

    this.extendJSON   = this._getExtendJson();
    this.extraEntries = this._getExtraEntries();    

    this.menuConfig = this._apexCreateMenuJson();

    if ( !this.element.is('button') ) {

      this.element.on('keydown', $.proxy(function( pEvent ){

        if ( pEvent.which == $.ui.keyCode.DOWN ) {
          pEvent.stopImmediatePropagation();
          pEvent.preventDefault();
          
          this._performFakeClickEvent();
        }
  
      }, this))
    }

    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_create', 'init APEX menu on element');
    
    this.menuContainer.menu( this.menuConfig );
    
    if ( this.options.isContextMenu ) {
      apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_create', 'force show method for context menu event');
      this.show( this.options.browserEvent );
    }

    if ( this.options.browserEvent.type == "click" ) {
      if ( this.options.action.executeOnPageInit == false ) {
        if ( this.options.dynamicActionScope == "live" ) {
          apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_create', 'force show method for click event with dynamic scope');

          this._performFakeClickEvent( true );
        }
        else {
          apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_create', 'force show method for click event without initialization on page load event.');
          this.show( this.options.browserEvent );
        }
      }

    }

    if ( this.options.listenToEvent != null ) {
      this.element.on( this.options.listenToEvent, $.proxy(this.show, this) );
    }
    
  },

  _performFakeClickEvent: function( pForce ){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_performFakeClickEvent', 'this.element', this.element);

    var e = jQuery.Event( 'click', { 
      target: this.element.get(0),
      pageX: this.element.offset().left,
      pageY: this.element.offset().top+this.element.outerHeight()
    } );

    this.show( e, pForce );
  },
//
//
  _destroy: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_destroy', 'this.element', this.element);
    //usuwaj wszystkie nadmiarowe elementy i menu ktore osadziles w body

    try{
      this.menuContainer.remove();
    } catch( pError ){
      apex.debug.message( this.C_LOG_ERROR, this.logPrefix, '_destroy removing menu container raised erroe', pError.message);
    }
    
    try{
      this.element.removeClass('is-active');
      this.element.removeAttr('data-menu');
      this.element.removeAttr('aria-haspopup');
      this.element.removeAttr('aria-expanded');

      this.element.removeClass('js-menuButton');
    
    }catch( pError ) {
      apex.debug.message( this.C_LOG_ERROR, this.logPrefix, '_destroy removing this.element attributes raised error', pError.message);
    }

  },
//
//
  _setOption: function( pKey, pValue ) {
    if ( pKey === "value" ) {
      pValue = this._constrain( pValue );
    }

    this._super( pKey, pValue );
  },  
  options: function( pOptions ){
    this._super( pOptions );
  },
//
//
  _setOptions: function( pOptions ) {
    this._super( pOptions );
  },
//
//
  _createMenuContainer: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_createMenuContainer');

    var div = $( '<div id="'+this.uniqueId+'"></div>' );

    if ( this._attrFixPosition() ) {
      div.addClass('pretiusapexmenulist-fixed');
    }

    return div;
  },
  _getFunctionContext: function(){
    var returnObject;
    
    returnObject = {
      "element": this.element,
      "id": this.uniqueId
    };

    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_getFunctionContext', returnObject);
    return returnObject;
  },
  _getExtraEntries: function(){
    var 
      func,
      funcBody = "",
      result = [];

    if ( this._attrAddExtraEntries() ) {
      apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_getExtraEntries');

      try {
        funcBody = ""+
          "this.triggeringElement = pTriggeringElement; \n"+
          "this.affectedElements = paffectedElements; \n"+
          "this.action = pAction; \n"+
          "this.browserEvent = pBrowserEvent; \n"+
          "this.data = pData; \n"+
          ""+this.options.action.attribute04+"\n"+
          "";
          
        func = new Function( 
          "pTriggeringElement", 
          "paffectedElements", 
          "pAction", 
          "pBrowserEvent", 
          "pData", 
          funcBody 
        );

        result = func.call(
          this._getFunctionContext(), 
          this.options.triggeringElement, 
          this.options.affectedElements, 
          this.options.action, 
          this.options.browserEvent, 
          this.options.data 
        );       

        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_getExtraEntries', 'result', result);        

        for ( var i in result ) {
          result[i].SEQ = result[i].seq;
          delete result[i].seq;
        }

      } catch( pError ) {
        this._printFunctionToConsole(this.options.action.attribute04);
        this._throwError( this.C_ERR_MSG_EXTRA_EXECUTE_JS, pError.message );
      }

      if ( result == undefined ) {
        //no result from function
        this._throwError( this.C_ERR_MSG_EXTRA_RETURN_UNDEFINED );
      }
      else if ( !(result instanceof Array) ) {
        //this._throwError( 'Override Behaviour returned invalid object.' );
        this._throwError( this.C_ERR_MSG_EXTRA_RETURN_INVALID );
      }
    }

    
    return result;
  },
  _checkExtendJson: function( pList, pId ){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_checkExtendJson');
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_checkExtendJson list', pList);        
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_checkExtendJson attr10', pId);

    var found = false;

    for ( var i in pList) {
      if ( pList[i].ENTRY_ATTRIBUTE_01 == pId ) {
        found = true;
        break;
      }

      if ( pList[i].items != undefined && pList[i].items instanceof Array) {
        found = this._checkExtendJson( pList[i].items, pId );
      }
    }

    return found;
  },
  _getExtendJson: function(){
    var 
      func,
      funcBody = "",
      result = {},
      listCopy = $.extend([], this.options.list.entries),
      checkResult;
      


    if ( this._attrOverrideBehaviour() ) {
      apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_getExtendJson');      

      try{
        funcBody = ""+
          "this.triggeringElement = pTriggeringElement; \n"+
          "this.affectedElements  = paffectedElements; \n"+
          "this.action            = pAction; \n"+
          "this.browserEvent      = pBrowserEvent; \n"+
          "this.data              = pData; \n"+
          ""+this.options.action.attribute03+"\n"+
          "";

        func = new Function( 
          "pTriggeringElement", 
          "paffectedElements", 
          "pAction", 
          "pBrowserEvent", 
          "pData", 
          funcBody 
        );

        result = func.call( 
          this._getFunctionContext(), 
          this.options.triggeringElement, 
          this.options.affectedElements, 
          this.options.action, 
          this.options.browserEvent, 
          this.options.data 
        );

      } catch( pError ) {
        this._printFunctionToConsole(this.options.action.attribute03);
        this._throwError( this.C_ERR_MSG_EXTEND_EXECUTE_JS, pError.message );
      }

      apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_getExtendJson result', result);

      if ( !(result instanceof Object) || result instanceof Array ) {
        this._throwError( this.C_ERR_MSG_EXTEND_RETURN_INVALID );
      }
      //tbd in next rlease: more detailed check on object type;

      //check if ids represents lists
      for ( var i in result ) {
        checkResult = this._checkExtendJson( listCopy, i );

        if ( !checkResult ) {
          apex.debug.message( this.C_LOG_WARNING, this.logPrefix, '_getExtendJson there is no entry with attribute 1 set to "'+i+'"');
        }
      }
    }

    return result;
  },
  _apexCallbackAfterClose: function( pEvent, pUi ){
    apex.debug.message( this.C_LOG_LEVEL6,  this.logPrefix, '_apexCallbackAfterClose');
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCallbackAfterClose', 'pEvent', pEvent);
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCallbackAfterClose', 'pUi'   , pUi);

    this.isVisible = false;

    if ( this.options.isContextMenu ) {
      this.destroy();  
    }

    if ( pUi.launcher == null && this._attrDisplayAtMousePosition() ) {
      apex.debug.message( this.C_LOG_DEBUG,  this.logPrefix, '_apexCallbackAfterClose', 'force focus to triggering element.');
      this.element.focus();
    }
  },
  _apexCallbackBeforeOpen: function( pEvent, pUi ){
    apex.debug.message( this.C_LOG_LEVEL6,  this.logPrefix, '_apexCallbackBeforeOpen');
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCallbackBeforeOpen', 'pEvent', pEvent);
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCallbackBeforeOpen', 'pUi'   , pUi);

    this.isVisible = true;

  },
  _apexCallbackCreate: function( pEvent, pUi ){
    apex.debug.message( this.C_LOG_LEVEL6,  this.logPrefix, '_apexCallbackCreate');
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCallbackCreate', 'pEvent', pEvent);
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCallbackCreate', 'pUi'   , pUi);
  },
  //https://stackoverflow.com/questions/1129216/sort-array-of-objects-by-string-property-value
  _sortArray: function( pProperty ) {
    var sortOrder = 1;

    pProperty = pProperty.toUpperCase();

    if(pProperty[0] === "-") {
        sortOrder = -1;
        pProperty = pProperty.substr(1);
    }
    return function (a,b) {
        var result = (a[pProperty] < b[pProperty]) ? -1 : (a[pProperty] > b[pProperty]) ? 1 : 0;
        return result * sortOrder;
    }    
  },
  _apexCreateMenuJson: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuJson');

    var 
      menu = {
        afterClose: $.proxy( this._apexCallbackAfterClose, this),
        beforeOpen: $.proxy( this._apexCallbackBeforeOpen, this),
        create    : $.proxy( this._apexCallbackCreate, this),
        iconType  : "fa"
      },
      listCopy = $.extend([], this.options.list.entries),
      removed;

/*
    //remove list entries where attribute 03 is set to true
    for ( var i in listCopy ) {
      if ( listCopy[i].ENTRY_ATTRIBUTE_03 == "true") {
        removed = listCopy.splice(i, 1);
        apex.debug.message( this.C_LOG_WARNING, this.logPrefix, '_apexCreateMenuJson', 'removing entry "'+removed[0].ENTRY_TEXT+'" because its hidden via A03', removed);
      }
    }
*/    

    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuJson', 'current list', $.extend([], listCopy));

    listCopy = listCopy.concat( this.extraEntries );

    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuJson', 'extended with extra entries', $.extend([], listCopy));

    listCopy.sort( this._sortArray('seq') );

    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuJson', 'sorted', $.extend([], listCopy));

    menu.items = this._apexCreateMenuEntries( listCopy );

    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuJson', 'out menu', menu);

    return menu;
  },
  _apexCreateMenuEntries: function( pList ){
    apex.debug.message( this.C_LOG_LEVEL6,  this.logPrefix, '_apexCreateMenuEntries');
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntries', pList);
    
    var 
      entriesArray = [],
      entry = {};

    for ( var i=0; i < pList.length; i++ ){
      entriesArray.push( this._apexCreateMenuEntry( pList[i] ) );
    }

    apex.debug.message( this.C_LOG_LEVEL6,  this.logPrefix, '_apexCreateMenuEntries out', entriesArray);


    return entriesArray;
    
  },
  _apexGetMenuItemType: function( pEntry ){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexGetMenuItemType', pEntry);

    if ( pEntry.ENTRY_ATTRIBUTE_07 == 'separator' ) {
      return this.C_ENTRY_TYPE_SEPARATOR;
    }
    else if ( pEntry.items != undefined ) {
      return this.C_ENTRY_TYPE_SUBMENU;
    }
    else {
      return this.C_ENTRY_TYPE_ACTION;
    }
  },
  _apexCreateMenuEntry: function( pEntry ){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry "'+pEntry.ENTRY_TEXT+'"');
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry', pEntry);


    //items
    var 
      entry = {},
      type = this._apexGetMenuItemType( pEntry ); 

    entry = {
      type       : type,
      labelKey   : pEntry.ENTRY_TEXT         == undefined ? pEntry.labelKey       : pEntry.ENTRY_TEXT,
      label      : pEntry.ENTRY_TEXT         == undefined ? pEntry.label          : pEntry.ENTRY_TEXT,
      icon       : pEntry.ENTRY_IMAGE        == undefined ? pEntry.icon           : pEntry.ENTRY_IMAGE,
      iconStyle  : pEntry.iconStyle,
      accelerator: pEntry.ENTRY_ATTRIBUTE_06 == undefined ? pEntry.accelerator    : pEntry.ENTRY_ATTRIBUTE_06,
      href       : pEntry.ENTRY_TARGET       == undefined ? pEntry.href           : pEntry.ENTRY_TARGET,
      id         : pEntry.ENTRY_ATTRIBUTE_01 == undefined ? undefined             : pEntry.ENTRY_ATTRIBUTE_01,
      action     : pEntry.action,
      disabled   : pEntry.disabled,
      hide       : pEntry.hide
    };

    if ( type == this.C_ENTRY_TYPE_SUBMENU ) {
      entry.menu = {
        "iconType": "fa",
        "items": this._apexCreateMenuEntries( pEntry.items )
      }
    }

    if ( this.extendJSON[ entry.id ] != undefined ) {
      apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry extend entry action', pEntry);

      entry.action = this.extendJSON[ entry.id ].action;

      //disable
      if ( pEntry.ENTRY_ATTRIBUTE_02 == "true" && this.extendJSON[ entry.id ].disabled == undefined) {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry disable entry based on entry attribute(2) because extend JSON doesn\'t have disabled property', pEntry);
        entry.disabled = true;
      } 
      else if ( this.extendJSON[ entry.id ].disabled != undefined ) {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry disable / enable entry based on entry disable function result', pEntry);
        entry.disabled = this.extendJSON[ entry.id ].disabled;    
      }
      else {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry entry is not disabled', pEntry);
        entry.disabled = false;
      } 

      //hide
      if ( pEntry.ENTRY_ATTRIBUTE_03 == "true" && this.extendJSON[ entry.id ].hide == undefined) {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry hide entry based on entry attribute(3) because extend JSON doesn\'t have hide property', pEntry);
        entry.hide = true;
      } 
      else if ( this.extendJSON[ entry.id ].hide != undefined ) {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry hide / show entry based on entry hide function result', pEntry);
        entry.hide = this.extendJSON[ entry.id ].hide;    
      }
      else {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry entry is not hidden', pEntry);
        entry.hide = false;
      } 

      //submenu
      if ( this.extendJSON[ entry.id ].items != undefined && this.extendJSON[ entry.id ].items.length > 0 ) {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry entry has submenu from extended JSON', pEntry);

        entry.menu = {
          "iconType": "fa",
          "items": this._apexCreateMenuEntries( this.extendJSON[ entry.id ].items )
        }

        //change entry type to submenu
        entry.type = this.C_ENTRY_TYPE_SUBMENU;
      }
  
    }
    else {
      apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry extend entry action', pEntry);

      if ( pEntry.ENTRY_ATTRIBUTE_02 == "true" ) {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apexCreateMenuEntry disable entry based on entry attribute(2)', pEntry);
        entry.disabled = true;
      }
    }

    return entry;
  },
  
  _convertObject: function(){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_convertObject', 'in', $.extend({},this.options.list.entries));

    var newList = [];

    for (var i in this.options.list.entries) {
      newList.push({
        ENTRY_IMAGE                 : this.options.list.entries[i].IMAGE,
        ENTRY_TARGET                : this.options.list.entries[i].TARGET,
        ENTRY_TEXT                  : this.options.list.entries[i].LABEL,
        ENTRY_IMAGE_ATTRIBUTES      : this.options.list.entries[i].IMAGE_ATTRIBUTE,
        ENTRY_IMAGE_ALT_ATTRIBUTE   : this.options.list.entries[i].IMAGE_ALT_ATTRIBUTE,
        ENTRY_ATTRIBUTE_01          : this.options.list.entries[i].ATTRIBUTE1,
        ENTRY_ATTRIBUTE_02          : this.options.list.entries[i].ATTRIBUTE2,
        ENTRY_ATTRIBUTE_03          : this.options.list.entries[i].ATTRIBUTE3,
        ENTRY_ATTRIBUTE_04          : this.options.list.entries[i].ATTRIBUTE4,
        ENTRY_ATTRIBUTE_05          : this.options.list.entries[i].ATTRIBUTE5,
        ENTRY_ATTRIBUTE_06          : this.options.list.entries[i].ATTRIBUTE6,
        ENTRY_ATTRIBUTE_07          : this.options.list.entries[i].ATTRIBUTE7,
        ENTRY_ATTRIBUTE_08          : this.options.list.entries[i].ATTRIBUTE8,
        ENTRY_ATTRIBUTE_09          : this.options.list.entries[i].ATTRIBUTE9,
        ENTRY_ATTRIBUTE_10          : this.options.list.entries[i].ATTRIBUTE10
      });
    }

    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_convertObject', 'out', newList);

    return newList;
  },
  _printFunctionToConsole: function( pFunctionBody ){
    var array = pFunctionBody.split("\n");
    for ( var i = 0; i < array.length; i++ ) {
      apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '#', array[i]);
    }
  },
//
//
  _throwError: function( pText ){
    apex.debug.message( this.C_LOG_LEVEL9, this.logPrefix, pText); 

    var 
      message = pText,
      messageText;

    for (var i=1; i < arguments.length; i++) {
      message = message.replace('%'+(i-1), arguments[i]);
    }

    messageText = message;

    message = ''+
      '<strong>'+this.C_PLUGIN_NAME+'</strong><br>'+
      //this.daName+'<br>'+
      '<span class="pretiusapexmenulist-errorMessage">'+message+'</span>';    

    apex.message.clearErrors();

    apex.message.showErrors( {
      type: apex.message.ERROR,
      location: "page",
      message: message
    } );

    apex.debug.message( this.C_LOG_ERROR, this.logPrefix, messageText); 

    this.destroy();
    throw 'Plugin stopped!';
  },
  
  _attrOverrideBehaviour: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_attrFixPosition');

    return this.options.action.attribute02.indexOf('OMB') > -1;
  },
  _attrFixPosition: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_attrFixPosition');

    return this.options.action.attribute02.indexOf('FP') > -1;
  },
  _attrAddExtraEntries: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_attrDisplayAtMousePosition');

    return this.options.action.attribute02.indexOf('EE') > -1;
  },
  _attrDisplayAtMousePosition: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_attrDisplayAtMousePosition');

    return this.options.action.attribute02.indexOf('DAMP') > -1;
  },
  getDebugObject: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, 'getDebugObject');

    return {
      "element": this.element.get(0),
      "options": $.extend({}, this.options),
      "widget": $.extend({}, this)
    };
  },
  show: function( pEvent, pForce ){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'show', this.getDebugObject()); 
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, 'show event', pEvent); 

    var x, y;

    if ( this.element.is('button') && this.options.isContextMenu == false && pForce == undefined){
      apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'show: element is button, let apex handle showing menu itself.'); 
      return void(0);
    }

    if ( this.isVisible ) {
      apex.debug.message( this.C_LOG_WARNING, this.logPrefix, 'show: menu is visible, don\'t show it again!');
      return void(0);
    }

    x = pEvent.pageX;
    y = pEvent.pageY;

    if ( this._attrDisplayAtMousePosition() ) {
      if ( x == 0 && y == 0 ) {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, 'menu was ment to display at position x="0" && y="0". Menu is aligned to triggering element.');
        this.menuContainer.menu("open", this.element);

      }
      else {
        apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, 'show at position x="'+x+'", y="'+y+'"');
        this.menuContainer.menu("open", x, y);
      }
    }
    else {
      this.menuContainer.menu("open", this.element);
    }
  },
  debounce: function(func, wait, immediate) {
    //apex.debug.log('debounce', 'func', func, 'wait', wait, 'immediate', immediate);

    var timeout;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        if (!immediate) func.apply(context, args);
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) func.apply(context, args);
    };
  },
  throttle: function(callback, limit) {
    var wait = false;                  // Initially, we're not waiting
    return function () {               // We return a throttled function
        if (!wait) {                   // If we're not waiting
            callback.call();           // Execute users function
            wait = true;               // Prevent future invocations
            setTimeout(function () {   // After a period of time
                wait = false;          // And allow future invocations
            }, limit);
        }
    }
  }
});