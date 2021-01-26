Ext.define('HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento3', {	
	 extend		: 'Ext.form.Panel',
    xtype		: 'xtypeFormularioTipoDocumento3',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento3',
    layout: 'fit',
    isEditForm: true,
    autoScroll: true,
    
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
			    	xtype: 'datefield',
			    	title: 'Fecha Obtención',
			    	name: 'fechaObtencion'
			    		
	            },
	            {
			    	xtype: 'datefield',
			    	title: 'Fecha Caducidad',
			    	name: 'fechaCaducidad'
	            },
	            {
			    	xtype: 'datefield',
			    	title: 'Fecha Etiqueta',
			    	name: 'fechaEtiqueta'
	
	            },
	            {
			    	xtype: 'combobox',
			    	title: 'Fecha Etiqueta',
			    	name: 'fechaEtiquetaCombo',
			    		store: Ext.create('Ext.data.Store',{								        		
			    			model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'calificacionEnergetica'}
							},
							autoLoad: true
						})	
	
	            },
	            {
			    	xtype: 'textfieldbase',
			    	title: 'Registro',
			    	name: 'registro'
	
	            }
           ]
    	}
    ]
	});