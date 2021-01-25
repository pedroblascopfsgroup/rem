/**
 *  Modelo para el tab Gestion economica Auditoria Desbloqueo
 */
Ext.define('HreRem.model.AuditoriaDesbloqueo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'idCombo'
    		},
    		{
    			name:'idEco'
    		},
    		{
    			name: 'idUsuario'
    		},
    		{
    			name: 'fechaDeDesbloqueo'
    		},
    		{
    			name: 'motivoDeDesbloqueo'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'gastoGestionEconomica.json',
		api: {
        }
    }

});