Ext.define('HreRem.view.activos.detalle.CargasActivo', {
      extend : 'HreRem.view.common.FormBase',
      xtype : 'cargasactivo',
      cls : 'panel-base shadow-panel',
      collapsed : false,
      disableValidation : true,
      reference : 'cargasactivo',
      scrollable : 'y',
      listeners : {
        boxready : 'cargarTabData'
      },

      recordName : "cargaTab",

      recordClass : "HreRem.model.ActivoCargasTab",

      requires : ['HreRem.model.ActivoCargasTab', 'HreRem.view.common.FieldSetTable'],

      initComponent : function() {
        var me = this;
        me.setTitle(HreRem.i18n('title.cargas'));
        var items = [

        {
              xtype : 'fieldset',
              collapsed : false,
              layout : {
                type : 'table',
                // The total column count must be specified here
                columns : 2,
                trAttrs : {
                  height : '30px',
                  width : '100%'
                },
                tdAttrs : {
                  width : '50%'
                },
                tableAttrs : {
                  style : {
                    width : '100%'
                  }
                }
              },
              items : [{
                    xtype : 'comboboxfieldbase',
                    fieldLabel : HreRem.i18n('fieldlabel.con.cargas'),
                    name : 'estadoActivoCodigo',
                    bind : {
                      store : '{comboSiNoRem}',
                      value : '{cargaTab.conCargas}',
                      readOnly: true
                    },
                    readOnly : true
                  },
                  {
                      xtype : 'textfieldbase',
                      fieldLabel : HreRem.i18n('fieldlabel.cargas.estado.cargas'),
                      name : 'estadoCargas',
                      bind : { 
                        value : '{cargaTab.estadoCargas}'
                      },
                      readOnly : true
                    },{
                    xtype : 'datefieldbase',
                    fieldLabel : HreRem.i18n('fieldlabel.fecha.revision.cargas'),
                    bind : {
                    	value: '{cargaTab.fechaRevisionCarga}',
                    	readOnly: '{cargaTab.unidadAlquilable}'
                    }
                  }

              ]
            }, {
              xtype : 'gridBase',
              title : HreRem.i18n('title.listado.cargas'),
              reference : 'listadoCargasActivo',
              topBar : true,
              //propagationButton : true, <- HREOS-2775 Este item se queda es standby 
              cls : 'panel-base shadow-panel',
              bind : {
                store : '{storeCargas}',
                topBar: '{!cargaTab.unidadAlquilable}'
              },
              selModel : {
                type : 'checkboxmodel'
              },
              columns : [{
                    text : HreRem.i18n('header.origen.dato'),
                    dataIndex : 'origenDatoDescripcion',
                    flex : 1
                  },{
                    text : HreRem.i18n('header.tipo.carga'),
                    dataIndex : 'tipoCargaDescripcion',
                    flex : 1
                  }, {
                    text : HreRem.i18n('header.subtipo.carga'),
                    flex : 1,
                    dataIndex : 'subtipoCargaDescripcion'
                  }, {
                    text : HreRem.i18n('header.estado.carga'),
                    flex : 1,
                    dataIndex : 'estadoDescripcion'
                  }, {
                      text : HreRem.i18n('header.subestado.carga'),
                      flex : 1,
                      dataIndex : 'subestadoDescripcion'
                  }, {
                    text : 'Estado carga econ&oacute;mica',
                    flex : 1,
                    dataIndex : 'estadoEconomicaDescripcion',
                    hidden:true,
                    disabled:true
                  }, {
                    text : HreRem.i18n('header.titular'),
                    flex : 1,
                    dataIndex : 'titular'
                  }, {
                    text : 'Importe registral',
                    dataIndex : 'importeRegistral',
                    renderer : function(value) {
                      return Ext.util.Format.currency(value);
                    },
                    flex : 1
                  }, {
                    text : 'Importe econ&oacute;mico',
                    dataIndex : 'importeEconomico',
                    renderer : function(value) {
                      return Ext.util.Format.currency(value);
                    },
                    flex : 1
                  }, {   
                	text : HreRem.i18n('fieldlabel.con.cargas.propias'),
		        	dataIndex: 'cargasPropias',
		        	renderer : function(value) {
		        		if(value == "1"){
		        			return "Si";
		        		}else if(value == "0"){
		        			return "No";
		        		}else {
		        			return "";
		        		}
	                },
		        	flex: 1
				  }

              ],
              dockedItems : [{
                    xtype : 'pagingtoolbar',
                    dock : 'bottom',
                    displayInfo : true,
                    bind : {
                      store : '{storeCargas}'
                    }
                  }],
              listeners : [{
                    afterrender : 'onRenderCargasList'
                  }, {
                    rowdblclick : 'onCargasListDobleClick'
                  }]
            }];

        me.addPlugin({
              ptype : 'lazyitems',
              items : items
            });
        me.callParent();
      },

      funcionRecargar : function() {
        var me = this;
        me.recargar = false;
        me.lookupController().cargarTabData(me);
        Ext.Array.each(me.query('grid'), function(grid) {
              grid.getStore().load();
            });
      }
    });