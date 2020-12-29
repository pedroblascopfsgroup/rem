Ext.define('HreRem.view.expedientes.ActivosAlquiladosGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'activosAlquiladosGrid',
    requires : [ 'HreRem.model.ActivoAlquiladosGrid'],
    reference : 'activoAlquiladoGridRef',
    recordName : "activoAlquiladoGrid",
    recordClass : "HreRem.model.ActivoAlquiladosGrid",
    bind: {
        store: '{storeActivosAlquilados}'
    },
    listeners:{
    	boxready: function() {
    		var me = this;
    		me.evaluarEdicion();
    	}
    },

    initComponent: function () {
     	var me = this;
     	//me.editOnSelect = ($AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL_BO_INM']));
		me.columns = [
				{
					dataIndex: 'numActivo',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.numActivo'),
		        	flex: 1
				},
				{
                    text : 'ID',
                    dataIndex : 'id',
                    hidden: true,
                    flex : 1
                },
				{
					dataIndex: 'subTipoActivo',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.subTipoActivo'),
		        	flex: 1
				},
				{
					dataIndex: 'municipio',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.municipio'),
					flex: 1
				},
				{
					dataIndex: 'direccion',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.direccion'),
					flex: 1
				},
				{
					dataIndex: 'rentaMensual',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.rentaMensual'),
					editor: {
						xtype:'numberfield'
					},
					flex: 1
				},
				{
					dataIndex: 'deudaActual',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.deudaActual'),
					editor: {
						xtype:'numberfield'
					},
					flex: 1
				},
				{
					dataIndex: 'conDeudas',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.conDeudas'),
					editor: {
						xtype: 'combobox',
		        		bind: {
		            		store: '{comboSiNoRemActivo}'
		            	},
		            	displayField: 'descripcion',
						valueField: 'codigo',
						autoLoad: true
					},
		            flex: 1
				},
				{
					dataIndex: 'inquilino',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.inquilino'),
					editor: {
						xtype: 'combobox',
		        		bind: {
		            		store: '{comboSiNoRemActivo}'
		            	},
		            	displayField: 'descripcion',
						valueField: 'codigo',
						autoLoad: true
					},
					flex: 1
				},
				{
					dataIndex: 'ofertante',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.ofertante'),
					editor: {
						xtype: 'combobox',
		        		bind: {
		            		store: '{comboSiNoRemActivo}'
		            	},
		            	displayField: 'descripcion',
						valueField: 'codigo',
						autoLoad: true
					},
		            flex: 1
				},
				{
					dataIndex: 'fechaFinContrato',
					text: HreRem.i18n('fieldlabel.condicion.expediente.activo.fechaFinContrato'),
					editor: {
		        		xtype: 'datefield'
		        	},
		            formatter: 'date("d/m/Y")',
		            flex: 1
				}
		    ];
		

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeActivosAlquilados}'
		            }
		        }
		    ];
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.getView().refresh() 
		    	return true;
		    };

		    me.callParent();
	        
	        
   },
   evaluarEdicion: function() {
		var me = this;
		var codigoEstado = me.lookupController().getViewModel().data.expediente.data.codigoEstado;
		if($AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL_BO_INM'])) {
			if(codigoEstado == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || codigoEstado == CONST.ESTADOS_EXPEDIENTE['PENDIENTE_SANCION']){
				me.setEditOnSelect(false);
			} else {
				me.setEditOnSelect(true);
			}
		}else{
			me.setEditOnSelect(false);
		}
   }
});
