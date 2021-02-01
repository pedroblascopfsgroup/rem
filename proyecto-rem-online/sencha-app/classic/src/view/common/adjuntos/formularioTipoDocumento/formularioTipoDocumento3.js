Ext.define('HreRem.view.activos.common.adjuntos.formularioTipoDocumento.formularioTipoDocumento3', {	
	 extend		: 'Ext.form.Panel',
    xtype		: 'xtypeFormularioTipoDocumento3',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento3',
    layout: 'fit',
    isEditForm: true,
    autoScroll: false,
    
    items: [
    		{
			xtype: 'fieldsettable',
			layout: {
				type: 'vbox',
				align:'center'
			},
			reference: 'fieldsetDocumentoIdentidad',
			collapsible: false,
			collapsed: false,
			border: false,
			cls:'formbase_no_shadow',
			padding: '60px 0 0 0',
			defaults: {
				addUxReadOnlyEditFieldPlugin: false
			},
			items: [
    	
	            {
			    	xtype: 'datefield',
			    	fieldLabel: 'Fecha Obtención',
			    	reference: 'fechaObtencion'
			    		
	            },
	            {
			    	xtype: 'datefield',
			    	fieldLabel: 'Fecha Caducidad',
			    	reference: 'fechaCaducidad'
	            },
	            {
			    	xtype: 'datefield',
			    	fieldLabel: 'Fecha Etiqueta',
			    	reference: 'fechaEtiqueta'
	
	            },
	            {
			    	xtype: 'combobox',
			    	fieldLabel: 'Fecha Etiqueta',
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
			    	fieldLabel: 'Registro',
			    	reference: 'registro'
	
	            }
           ]
    	}
    ]
	});