Ext.define('HreRem.view.activos.detalle.InformacionCatastroGrid', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'informacionCatastroGrid',
    topBar		: false,
    removeButton : false,
    addButton: false,
    requires	: ['HreRem.model.Catastro'],
    editOnSelect: false,
    controller: 'activodetalle',
    viewModel: {
       type: 'activodetalle'
    },
	
    initComponent: function () {
    	
    	var me = this;
    	var isDatosRem = false;
    	if(me.reference == "informacionCatastroGridRefRem"){
    		isDatosRem = true;
    		me.setTitle(HreRem.i18n('title.datos.rem'));
    	}else{
    		me.setTitle(HreRem.i18n('title.catastro'));
    	}
    	
    	me.columns= [
    		{ 
    			text: HreRem.i18n('fieldlabel.incluir'),
	    		xtype: 'checkcolumn', 
	    		dataIndex: 'check',
	    		reference: 'check',
	    		name:'check',
	    		flex: 0.5,
	    		hidden:isDatosRem
    		},
		    {   
				text: HreRem.i18n('fieldlabel.referencia.catastral'),
	        	dataIndex: 'refCatastral',
	        	flex: 1.5,
	        	hidden:isDatosRem
	        },
			{
	            text: HreRem.i18n('fieldlabel.superficie.parcela'),
	            dataIndex: 'superficieParcela',
	            renderer: Ext.util.Format.numberRenderer('0,000.00'),
	        	flex: 1
	        },
	        
	        {   text: HreRem.i18n('fieldlabel.superficie.construida'),
	        	dataIndex: 'superficieConstruida',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
	        	flex: 1
	        },
	        {   text: HreRem.i18n('fieldlabel.superficie.repercusion.elementos.comunes'), 
	        	dataIndex: 'superficieReperComun',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
	        	flex: 1
	        },
	        {
	            text: HreRem.i18n('fieldlabel.anyo.construccion'),
	            dataIndex: 'anyoConstruccion',
	        	flex: 1
	        },
	        
	        {   text: HreRem.i18n('fieldlabel.codigo.postal'),
	        	dataIndex: 'codigoPostal',
	        	flex: 1
	        },
	        {
	            text: HreRem.i18n('fieldlabel.tipo.via'),
	            dataIndex: 'tipoVia',
	        	flex: 1
	        },
	        {   text: HreRem.i18n('fieldlabel.nombre.via'),
	        	dataIndex: 'nombreVia',
	        	flex: 1
	        },
	        {   text: HreRem.i18n('fieldlabel.numero.via'),
	        	dataIndex: 'numeroVia',
	        	flex: 0.5
	        },
	        {   text: HreRem.i18n('fieldlabel.direccion'),
	        	dataIndex: 'direccion',
	        	flex: 1
	        }
	      
	       	        
	    ]; 	
      
    	me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'reclamacionesactivolistPaginationToolbar',
	            inputItemWidth: 100,
	            displayInfo: true,
	            store: me.store
	        }
        ];    
        me.callParent();

        
    }

});