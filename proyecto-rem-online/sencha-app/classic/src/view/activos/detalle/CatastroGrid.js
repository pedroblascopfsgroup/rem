Ext.define('HreRem.view.activos.detalle.CatastroGrid', {
	extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'catastroGrid',
    reference	: 'catastroGridRef',
    topBar		: true,
    addButton	: true,
    requires	: ['HreRem.model.Catastro'],
    editOnSelect: false,
    
    controller: 'activodetalle',
    viewModel: {
       type: 'activodetalle'
    },

    bind : {
    	store : '{storeCatastro}'
    },	
    listeners:{
		rowdblclick: 'abrirVentanaEditarCatastro'
	},
    initComponent: function () {
    	
    	
    	var me = this;
    	
    	var coloredRender = function (value, metaData, record, rowIndex, colIndex, view) {
			metaData.style = "white-space: normal;";
    		if(value){	    		
    			return value;
    		} else {
	    		return '-';
	    	}
    	};
    	
    	me.setTitle(HreRem.i18n('title.catastro'));
    	
    	me.topBar = $AU.userHasFunction('EDITAR_INFO_ADMINISTRATIVA_ACTIVO');
    	me.editOnSelect = $AU.userHasFunction('EDITAR_INFO_ADMINISTRATIVA_ACTIVO');
    	
    	me.columns= [
    		{
	        	dataIndex: 'idActivoCatastro',
	        	hidden: true
    		},
    		{
    			dataIndex: 'idActivo',
	        	hidden: true
    		},
		    {   
				text: HreRem.i18n('fieldlabel.referencia.catastral'),
	        	dataIndex: 'refCatastral',
	        	flex: 1.5
	        },
            {
            	xtype: 'actioncolumn',
            	text	 : HreRem.i18n('fieldlabel.referencia.catastral.correcto'),
                flex	 : 0.7,
                dataIndex: 'correcto',
                renderer: coloredRender,
                items: [{
			            getClass: function(v, metadata, record ) {

			            	var catCorrecto = record.get('correcto');
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
            {   text: HreRem.i18n('fieldlabel.valor.catastral.construccion'),
	        	dataIndex: 'valorCatastralConst',
	        	renderer: function(value) {
	        		return Ext.util.Format.currency(value);
	        	},
	        	flex: 0.7
	        },
	        {   text: HreRem.i18n('fieldlabel.valor.catastral.suelo'),
	        	dataIndex: 'valorCatastralSuelo',
	        	renderer: function(value) {
	        		return Ext.util.Format.currency(value);
	        	},
	        	flex: 0.7
	        },
	        {   text: HreRem.i18n('fieldlabel.fecha.revision.valor.catastral'),
	        	dataIndex: 'fechaRevValorCatastral',
	        	formatter: 'date("d/m/Y")',
                flex: 0.7
	        },
	        {   text: HreRem.i18n('fieldlabel.fecha.alta.catastro'),
	        	dataIndex: 'fechaAltaCatastro',
	        	formatter: 'date("d/m/Y")',
                flex: 0.7 
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
	        {
	            text: HreRem.i18n('fieldlabel.anyo.construccion'),
	            dataIndex: 'anyoConstruccion',
	        	flex: 0.5
	        }, 
	        {   text: HreRem.i18n('fieldlabel.codigo.postal'),
	        	dataIndex: 'codigoPostal',
	        	flex: 0.5
	        }, 
	        {
	            text: HreRem.i18n('fieldlabel.tipo.via'),
	            dataIndex: 'tipoVia',
	            flex: 0.5
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
	        	flex: 0.5
	        },
	        {   text:  HreRem.i18n('fieldlabel.escalera'),
	        	dataIndex: 'escalera',
	        	flex: 0.5
	        },
	        {
	        	text: HreRem.i18n('fieldlabel.provincia'),
	        	dataIndex: 'provincia',
	        	flex: 1
	        },
	        {   
	        	text: HreRem.i18n('fieldlabel.municipio'),
	        	dataIndex: 'municipio',
	        	flex: 1
	        },
	        {   
	        	text: HreRem.i18n('fieldlabel.latitud'),
	        	dataIndex: 'latitud',
	        	flex: 1
	        },
	        {   
	        	text: HreRem.i18n('fieldlabel.longitud'),
	        	dataIndex: 'longitud',
	        	flex: 1
	        }
     
	    ]; 	
//	    dockedItems : [
//	        {
//	            xtype: 'pagingtoolbar',
//	            dock: 'bottom',
//	            displayInfo: true,
//	            bind: {
//	                store: '{storeCatastro}'
//	            }
//	        }
//	    ];        
        me.callParent();

        
    },
    
    onAddClick: function(btn){
		var me = this;
 		Ext.create("HreRem.view.activos.detalle.VentanaCrearRefCatastral", {idActivo: me.idActivo, parent: me}).show();
   },  
   
   onDeleteClick : function() {
		var me = this;
		var grid = me;
		var idCatastro = me.getSelection()[0].getData().idCatastro;
		Ext.Msg.show({
			title : HreRem.i18n('title.mensaje.confirmacion'),
			msg : HreRem.i18n('msg.desea.eliminar'),
			buttons : Ext.MessageBox.YESNO,
			fn : function(buttonId) {
				if (buttonId == 'yes') {
					grid.mask(HreRem.i18n("msg.mask.loading"));
					url = $AC.getRemoteUrl('catastro/eliminarCatastro');
					Ext.Ajax.request({
						url : url,
						method : 'GET',
						params : {
							id :idCatastro
						},
						success : function(response, opts) {
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						},
						failure : function(record, operation) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
						},
						callback : function(record, operation) {
							grid.unmask();
							grid.getStore().load();
						}
					});
					
				}
			}
		});
	}

});