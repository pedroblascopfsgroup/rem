Ext.define('HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento2', {	
	 extend		: 'Ext.form.Panel',
    xtype		: 'xtypeFormularioTipoDocumento2',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento2',
    layout: 'fit',
    isEditForm: true,
    autoScroll: true,
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'displayfield'
    },
    
    items: [
    		{
			xtype: 'fieldsettable',
			layout: {
				type: 'vbox',
				align:'center'
			},
			margin: '20',
			reference: 'fieldsetDocumentoIdentidad',
			collapsible: false,
			defaults: {
				addUxReadOnlyEditFieldPlugin: false
			},
			items: [
	    	
	            {
			    	xtype: 'combosino',
			    	title: 'Aplica'
	            },
	            {
			    	xtype: 'datefield',
			    	title: 'Fecha Emisión',
			    	name: 'fechaEmision'
	            },
	            {
			    	xtype: 'datefield',
			    	title: 'Fecha Caducidad',
			    	name: 'fechaCaducidad'
	
	            }
	            ]
    		}
	            
    ]
	});