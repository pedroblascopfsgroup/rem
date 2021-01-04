Ext.define('HreRem.view.activos.common.adjuntos.formularioTipoDcomento1', {	
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'xtypeFormularioTipoDocumento1',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento1',
    layout: 'form',
    isEditForm: true,
    autoScroll: true,
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'displayfield'
    },


    items: [
	          
            {
		    	xtype: 'combosino',
		    	title: 'Aplica'
            },
            {
		    	xtype: 'Datefield',
		    	title: 'Fecha emisión',
		    	name: 'fechaEmision'
            }
    ]
	});