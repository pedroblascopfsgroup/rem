/**
 * The main application class. An instance of this class is created by app.js when it
 * calls Ext.application(). This is the ideal place to handle application launch and
 * initialization details.
 */
Ext.define('HreRem.Application', {
    extend: 'Ext.app.Application',
    
    name: 'HreRem',
    
    requires: ['HreRem.ux.i18n.Bundle', 'HreRem.view.Viewport','Ext.window.MessageBox', 'HreRem.ux.window.MessageBox', 
    'HreRem.view.login.Login', 'HreRem.ux.util.Validations', 'HreRem.ux.util.Constants', 'HreRem.ux.util.Utils'],
    
    controllers: [
        'AuthenticationController', 'RootController',  'ActivosController','FavoritosController', 'AgendaController', 
        'WindowsController', 'RefreshController'
    ],
    
    stores: ['dd.EntidadPropietaria', 'dd.EstadosPropuesta', 'dd.Provincias'],
            
    bundle: {
        bundle: 'messages',
        lang: 'es',
        path: 'resources/locale',
        noCache: true
    }
    
 });
