/**
 * @class HreRem.Application
 * @author Jose Villel
 * 
 * La clase aplicación que extiende de Ext.app.Application y que será instanciada al inicio de la aplicación desde el app.js
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

    stores: ['dd.EntidadPropietaria', 'dd.EstadosPropuesta', 'dd.Provincias', 'dd.EstadosPropuestaActivo', 'dd.Municipios'],

    bundle: {
        bundle: 'messages',
        lang: 'es',
        path: 'resources/locale',
        noCache: true
    }

 });
