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
    	me.setTitle(HreRem.i18n('title.catastro'));
    	
    	me.topBar = $AU.userHasFunction('EDITAR_INFO_ADMINISTRATIVA_ACTIVO');
    	me.editOnSelect = $AU.userHasFunction('EDITAR_INFO_ADMINISTRATIVA_ACTIVO');
    	
    	me.columns= [
		    {   
				text: HreRem.i18n('fieldlabel.referencia.catastral'),
	        	dataIndex: 'refCatastral',
	        	flex: 2
	        },
	        {
				text: HreRem.i18n('fieldlabel.poligono'),
	        	dataIndex: 'poligono'
	        },	
			{
	            text: HreRem.i18n('fieldlabel.parcela'),
	            dataIndex: 'parcela',
	        	flex: 1
	        },
	        {   
	        	text: HreRem.i18n('fieldlabel.titular.catastral'),
	        	dataIndex: 'titularCatastral',
	        	flex: 1
	        },
	        
	        {   text: HreRem.i18n('fieldlabel.superficie.construida'),
	        	dataIndex: 'superficieConstruida',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00')
	        },
	        {   text: HreRem.i18n('fieldlabel.superficie.util'),
	        	dataIndex: 'superficieUtil',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00')
	        },
	        {   text: HreRem.i18n('fieldlabel.superficie.repercusion.elementos.comunes'), 
	        	dataIndex: 'superficieReperComun',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00')
	        },
	        {   text: HreRem.i18n('fieldlabel.superficie.parcela'), 
	        	dataIndex: 'superficieParcela',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00')
	        },
	        {   text: HreRem.i18n('fieldlabel.superficie.suelo'),
	        	dataIndex: 'superficieSuelo',
	        	renderer: Ext.util.Format.numberRenderer('0,000.00')
	        },
	        {   text: HreRem.i18n('fieldlabel.valor.catastral.construccion'),
	        	dataIndex: 'valorCatastralConst',
	        	renderer: function(value) {
	        		return Ext.util.Format.currency(value);
	        	},
	        	flex: 1
	        },
	        {   text: HreRem.i18n('fieldlabel.valor.catastral.suelo'),
	        	dataIndex: 'valorCatastralSuelo',
	        	renderer: function(value) {
	        		return Ext.util.Format.currency(value);
	        	},
	        	flex: 1
	        },
	        {   text: HreRem.i18n('fieldlabel.fecha.revision.valor.catastral'),
	        	dataIndex: 'fechaRevValorCatastral',
	        	formatter: 'date("d/m/Y")',
                flex: 1 
	        },
	        {   text: HreRem.i18n('fieldlabel.fecha.alta.catastro'),
	        	dataIndex: 'fechaAltaCatastro',
	        	formatter: 'date("d/m/Y")',
                flex: 1 
	        },
	        {   text: HreRem.i18n('fieldlabel.fecha.baja.catastro'),
	        	dataIndex: 'fechaBajaCatastro',
	        	formatter: 'date("d/m/Y")',
                flex: 1 
	        },
	        {   
	        	text: HreRem.i18n('fieldlabel.observaciones'),
	        	dataIndex: 'observaciones',
	        	flex: 1
	        },
	        {
	        	text: HreRem.i18n('fieldlabel.resultadoSiNO'),
	        	dataIndex: 'resultadoSiNO', 
	        	renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboSiNoRem').findRecord('codigo', value);
		            var descripcion;
		        	if(!Ext.isEmpty(foundedRecord)) {
		        		descripcion = foundedRecord.getData().descripcion;
		        	}
		            return descripcion;
		        },
	        	flex: 1
	        
	        	       
	        },
	        {   
	        	text: HreRem.i18n('fieldlabel.fechaSoliciud901'),
	        	dataIndex: 'fechaSolicitud901',
	        	formatter: 'date("d/m/Y")',
	        	flex: 1
	        },
	        {   
	        	text: HreRem.i18n('fieldlabel.alteracion.catastral'),
	        	dataIndex: 'fechaAlteracion',
	        	formatter: 'date("d/m/Y")',
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