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
			xtype: 'formBase',
			reference: 'adjuntarDocumentoFormRef2',
			collapsed: false,
		 		scrollable	: 'y',
		 		layout: 'fit',
			cls:'formbase_no_shadow',
			items: [

				 {
			    	xtype: 'combosino',
			    	fieldLabel: 'Aplica',
			    	reference : 'aplica',
			    	value : '{wizardAdjuntarDocumentoModel.aplica}'
	            },
	            {
			    	xtype: 'datefield',
			    	fieldLabel: 'Fecha emisión',
			    	reference: 'fechaEmision',
			    	value : '{wizardAdjuntarDocumentoModel.fechaEmision}'
	            },
	            {
			    	xtype: 'datefield',
			    	fieldLabel: 'Fecha Caducidad',
			    	name: 'fechaCaducidad',
			    	value : '{wizardAdjuntarDocumentoModel.fechaCaducidad}'
	
	            }
	            ]
    		}       
    	]
	});