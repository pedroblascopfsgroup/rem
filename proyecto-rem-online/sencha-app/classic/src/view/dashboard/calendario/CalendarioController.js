Ext.define('HreRem.view.dashboard.calendario.CalendarioController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.calendariocontroller',


		// Funcion que se ejecuta al hacer click en el botón limpiar
		onCleanFiltersClick: function(btn) {
			
			btn.up('panel').getForm().reset();
				
		},
		
		control: {
		
			'calendarmain' : {
				eventclick: function(vw, rec, el)
				{
					//debugger;
	            	this.showEditWindow(rec, el);
	            	this.clearMsg();
	            	scope: this
	        	},
	        	'eventover': function(vw, rec, el)
	        	{
                    //console.log('Entered evt rec='+rec.data.Title+', view='+ vw.id +', el='+el.id);
                },
                'eventout': function(vw, rec, el){
                    //console.log('Leaving evt rec='+rec.data.Title+', view='+ vw.id +', el='+el.id);
                },
                'eventadd': {
                    fn: function(cp, rec){
                        this.showMsg('Event '+ rec.data.Title +' was added');
                    },
                    scope: this
                },
                'eventupdate': {
                    fn: function(cp, rec){
                        this.showMsg('Event '+ rec.data.Title +' was updated');
                    },
                    scope: this
                },
                'eventcancel': {
                    fn: function(cp, rec){
                        // edit canceled
                    },
                    scope: this
                },
               /* 'viewchange': {
                    fn: function(p, vw, dateInfo){
                    	debugger;
                        if(this.editWin){
                            this.editWin.hide();
                        }
                        if(dateInfo){
                        	if (Ext.getCmp('app-nav-picker')) {
	                            // will be null when switching to the event edit form so ignore
	                            Ext.getCmp('app-nav-picker').setValue(dateInfo.activeDate);
	                            this.updateTitle(dateInfo.viewStart, dateInfo.viewEnd);
	                           }
                        }
                    },
                    scope: this
                },
  */              'dayclick': {
                    fn: function(vw, dt, ad, el){
                        this.showEditWindow({
                            StartDate: dt,
                            IsAllDay: ad
                        }, el);
                        this.clearMsg();
                    },
                    scope: this
                },
                'rangeselect': {
                    fn: function(win, dates, onComplete){
                        this.showEditWindow(dates);
                        this.editWin.on('hide', onComplete, this, {single:true});
                        this.clearMsg();
                    },
                    scope: this
                },
                'eventmove': {
                    fn: function(vw, rec){
                        var mappings = Ext.calendar.data.EventMappings,
                            time = rec.data[mappings.IsAllDay.name] ? '' : ' \\a\\t g:i a';
                        
                        rec.commit();
                        
                        this.showMsg('Event '+ rec.data[mappings.Title.name] +' was moved to '+
                            Ext.Date.format(rec.data[mappings.StartDate.name], ('F jS'+time)));
                    },
                    scope: this
                },
                'eventresize': {
                    fn: function(vw, rec){
                        rec.commit();
                        this.showMsg('Event '+ rec.data.Title +' was updated');
                    },
                    scope: this
                },
                'eventdelete': {
                    fn: function(win, rec){
                        this.eventStore.remove(rec);
                        this.showMsg('Event '+ rec.data.Title +' was deleted');
                    },
                    scope: this
                },
                'initdrag': {
                    fn: function(vw){
                        if(this.editWin && this.editWin.isVisible()){
                            this.editWin.hide();
                        }
                    },
                    scope: this
                }
	        }
	        
		},
		
/*
		eventclick: function(vw, rec, el){
			debugger;
            this.showEditWindow(rec, el);
            this.clearMsg();
       },*/
       
       
       // The edit popup window is not part of the CalendarPanel itself -- it is a separate component.
    // This makes it very easy to swap it out with a different type of window or custom view, or omit
    // it altogether. Because of this, it's up to the application code to tie the pieces together.
    // Note that this function is called from various event handlers in the CalendarPanel above.
    showEditWindow : function(rec, animateTarget){
        if(!this.editWin){
            this.editWin = Ext.create('Ext.calendar.form.EventWindow', {
                calendarStore: this.calendarStore,
                listeners: {
                    'eventadd': {
                        fn: function(win, rec){
                            win.hide();
                            rec.data.IsNew = false;
                            this.eventStore.add(rec);
                            this.eventStore.sync();
                            this.showMsg('Event '+ rec.data.Title +' was added');
                        },
                        scope: this
                    },
                    'eventupdate': {
                        fn: function(win, rec){
                            win.hide();
                            rec.commit();
                            this.eventStore.sync();
                            this.showMsg('Event '+ rec.data.Title +' was updated');
                        },
                        scope: this
                    },
                    'eventdelete': {
                        fn: function(win, rec){
                            this.eventStore.remove(rec);
                            this.eventStore.sync();
                            win.hide();
                            this.showMsg('Event '+ rec.data.Title +' was deleted');
                        },
                        scope: this
                    },
                    'editdetails': {
                        fn: function(win, rec){
                            win.hide();
                            Ext.getCmp('app-calendar').showEditForm(rec);
                        }
                    }
                }
            });
        }
        this.editWin.show(rec, animateTarget);
    },
        
    // The CalendarPanel itself supports the standard Panel title config, but that title
    // only spans the calendar views.  For a title that spans the entire width of the app
    // we added a title to the layout's outer center region that is app-specific. This code
    // updates that outer title based on the currently-selected view range anytime the view changes.
    updateTitle: function(startDt, endDt){
        var p = Ext.getCmp('app-center'),
            fmt = Ext.Date.format;
        
        if(Ext.Date.clearTime(startDt).getTime() === Ext.Date.clearTime(endDt).getTime()){
            p.setTitle(fmt(startDt, 'F j, Y'));
        }
        else if(startDt.getFullYear() === endDt.getFullYear()){
            if(startDt.getMonth() === endDt.getMonth()){
                p.setTitle(fmt(startDt, 'F j') + ' - ' + fmt(endDt, 'j, Y'));
            }
            else{
                p.setTitle(fmt(startDt, 'F j') + ' - ' + fmt(endDt, 'F j, Y'));
            }
        }
        else{
            p.setTitle(fmt(startDt, 'F j, Y') + ' - ' + fmt(endDt, 'F j, Y'));
        }
    },
    
    // This is an application-specific way to communicate CalendarPanel event messages back to the user.
    // This could be replaced with a function to do "toast" style messages, growl messages, etc. This will
    // vary based on application requirements, which is why it's not baked into the CalendarPanel.
    showMsg: function(msg){
        Ext.fly('app-msg').update(msg).removeCls('x-hidden');
    },
    clearMsg: function(){
        Ext.fly('app-msg').update('').addCls('x-hidden');
    },
    
    // OSX Lion introduced dynamic scrollbars that do not take up space in the
    // body. Since certain aspects of the layout are calculated and rely on
    // scrollbar width, we add a special class if needed so that we can apply
    // static style rules rather than recalculate sizes on each resize.
    checkScrollOffset: function() {
        var scrollbarWidth = Ext.getScrollbarSize ? Ext.getScrollbarSize().width : Ext.getScrollBarWidth();
        
        // We check for less than 3 because the Ext scrollbar measurement gets
        // slightly padded (not sure the reason), so it's never returned as 0.
        if (scrollbarWidth < 3) {
            Ext.getBody().addCls('x-no-scrollbar');
        }
        if (Ext.isWindows) {
            Ext.getBody().addCls('x-win');
        }
    }

       
});







