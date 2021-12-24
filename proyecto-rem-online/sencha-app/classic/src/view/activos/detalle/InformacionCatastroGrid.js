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
    minHeight: 82,
    overflowY: 'scroll',
    
    initComponent: function () {
    	
    	var me = this;
    	var isDatosRem = false;
    	
    	var coloredRender = function (value, metaData, record, rowIndex, colIndex, view) {
			metaData.style = "white-space: normal;";
    		if(value){	   		
    			return value;
    		} else {
	    		return '-';
	    	}
    	};
    	
    	if(me.reference == "informacionCatastroGridRefRem"){
    		isDatosRem = true;
    		me.setTitle(HreRem.i18n('title.datos.rem'));
    		
    	}else{
    		me.setTitle(HreRem.i18n('title.catastro'));
    		me.minHeight=300;
    		me.maxHeight=300;
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
    			xtype: 'actioncolumn',
	        	dataIndex: 'catastroCorrecto',
	        	flex: 0.2,
	        	hidden:isDatosRem,
	        	renderer: coloredRender,
                items: [{
		            getClass: function(v, metadata, record ) {
		            	var catCorrecto = record.get('catastroCorrecto');
						if(catCorrecto === "true")  {
     						return 'app-tbfiedset-ico icono-tickok no-pointer';
 						}else if(catCorrecto === "false"){
     						return 'app-tbfiedset-ico icono-tickko no-pointer';
 						}else {
     						return 'app-tbfiedset-ico icono-tickinterrogante no-pointer';
     					}			            	
		            }
		        }]
	        },
		    {   
				text: HreRem.i18n('fieldlabel.referencia.catastral'),
	        	dataIndex: 'refCatastral',
	        	flex: 1.5,
	        	hidden:isDatosRem
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
	        {   text: HreRem.i18n('fieldlabel.puerta'),
	        	dataIndex: 'puerta',
	        	flex: 0.5
	        },
	        {   text: HreRem.i18n('header.num.planta'),
	        	dataIndex: 'planta',
	        	flex: 1
	        },
	        {
	        	text: HreRem.i18n('fieldlabel.domicilio'),
	        	dataIndex: 'domicilio',
	        	flex: 1
	        },
	        {   text: HreRem.i18n('fieldlabel.codigo.postal'),
	        	dataIndex: 'codigoPostal',
	        	flex: 0.5
	        }, 
	        {
	            text: HreRem.i18n('fieldlabel.anyo.construccion'),
	            dataIndex: 'anyoConstruccion',
	        	flex: 0.5
	        },
			{
	            text: HreRem.i18n('fieldlabel.superficie.parcela'),
	            dataIndex: 'superficieParcela',
	            renderer: Ext.util.Format.numberRenderer('0,000.00'),
	        	flex: 0.5
	        },
	        
	        {   text: HreRem.i18n('fieldlabel.superficie.construida'),
	        	dataIndex: 'superficieConstruida',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
	        	flex: 0.5
	        },
	        {   text: HreRem.i18n('fieldlabel.superficie.repercusion.elementos.comunes'), 
	        	dataIndex: 'superficieReperComun',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
	        	flex: 0.5
	        }
	       
	    ]; 	
      
//    	if(!isDatosRem){
//	    	me.dockedItems = [
//		        {
//		            xtype: 'pagingtoolbar',
//		            dock: 'bottom',
//		            inputItemWidth: 100,
//		            displayInfo: true,
//		            store: me.store
//		        }
//	        ];  
//    	}
    	
        me.callParent();

        
    }

});