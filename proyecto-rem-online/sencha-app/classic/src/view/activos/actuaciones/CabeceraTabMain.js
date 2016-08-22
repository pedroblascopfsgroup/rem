Ext.define('HreRem.view.activos.actuaciones.CabeceraTabMain', {	
    extend		: 'Ext.form.Panel',
    xtype		: 'cabeceratabmain',
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    reference: 'cabeceraactuacionref',
    title: 'Datos Generales',
    layout: 'form',
    
    defaults: {
        layout: 'column',
        defaultType: 'displayfield',
       	width: '100%'
    },
    
    items:[{
    	xtype: 'fieldset',
    	title: 'Datos de la actuación',
    	defaults:{
    		layout:'column',
    		width: '50%'
    	},
        items: [
            { 
            	fieldLabel: 'Tipo Actuación',
	        	name: 'tipoActuacion'
            },{ 
            	fieldLabel: 'Actuación Original',
	        	name: 'tipoActuacionPadre'
            },{ 
            	fieldLabel: 'Código',
        		name: 'idActuacion'
            },{ 
            	fieldLabel: 'Estado',
	        	name: 'estado'
            },{ 
            	fieldLabel: 'Fecha Inicio',
	        	name: 'fechaInicio'
            },{ 
            	fieldLabel: 'Fecha Fin',
	        	name: 'fechaFin'
            },{ 
            	fieldLabel: 'Cliente',
	        	name: 'cliente'
            },{ 
            	fieldLabel: 'Gestor',
	        	name: 'gestor'
            }
        ]
    }
	]
    
    
    


});