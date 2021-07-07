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
			    	reference : 'primeroxtypeFormularioTipoDocumento3',
			    	hidden : true
	            },
    	
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
	            xtype: 'comboboxfieldbase',
	            reference: 'calificacionEnergetica',
	            fieldLabel: 'Calificacion Energetica',
        		//editable: false,
        		bind:{
        		store: '{storeEnergia}'
        		}
	            },
	            {
			    	xtype: 'textfield',
			    	fieldLabel: 'Registro',
			    	reference: 'registro'
	
	            }
           ]
    	}
    ]
	});