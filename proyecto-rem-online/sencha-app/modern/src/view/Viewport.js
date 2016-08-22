/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting causes an instance of this class to be created and
 * added to the Viewport container.
 */
Ext.define('HreRem.view.Viewport', {
    extend: 'Ext.Container',
    xtype: 'pageblank',

    anchor : '100%',

    layout:{
        type:'vbox',
        pack:'center',
        align:'center'
    },
    items: [
        {
            xtype: 'container',
            style: {fontSize: '60px'},
            html: '<div><span class=\'x-fa fa-expeditedssl\'></span></div>'
        },
        {
            xtype: 'container',
            style: {fontSize: '20px'},
            html: 'No disponible'
        }
    ]
});
