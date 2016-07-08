Ext.define('HreRem.view.ViewportModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.mainviewport',
    
    data: {  
    	currentUser: null,
        defaultView: 'agenda',
        currentView: null,
        defaultHeaderHeight: 55,
        version: '1.0.0'
    }
});
