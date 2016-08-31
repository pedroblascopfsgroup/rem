Ext.define('HreRem.view.activos.detalle.DatosComunidadActivo', {
      extend : 'HreRem.view.common.FormBase',
      xtype : 'datoscomunidadactivo',
      cls : 'panel-base shadow-panel',
      collapsed : false,
      disableValidation: true,
      reference : 'datoscomunidadactivo',
      scrollable : 'y',
      recordName : "activo",

      recordClass : "HreRem.model.Activo",

      requires : ['HreRem.model.Activo'],

      initComponent : function() {

        var me = this;
        me.setTitle(HreRem.i18n('title.comunidad.propietarios'));

        var items = [
        			{
              			xtype : 'fieldsettable',
              			defaultType : 'textfieldbase',
              			reference : 'fieldsetComunidad',
              			// disabled: true,
              			title : HreRem.i18n('title.datos.identificativos'),
              			items : [
              						{
	                    				xtype : 'comboboxfieldbase',
					                    allowBlank: false,
					                    fieldLabel : HreRem.i18n('fieldlabel.comunidad.propietarios.constituida'),
					                    bind : {
					                      store : '{comboSiNoRem}',
					                      value : '{activo.constituida}'
					                    },
			    						listeners: {
						                	change: 'onComunidadNoConstituida'
						            	}
                  					}, 
                  					{
					                    xtype : 'fieldset',
					                    height: 360,
					                    margin: '0 10 0 0',
					                    layout : {
					                    	type : 'table',
					                      	trAttrs : {
						                        height : '45px',
						                        width : '100%'
					                      	},
					                      	columns : 1,
					                      	tableAttrs : {
					                        	style : {
					                          				width : '100%'
					                        	}
					                      	}
                    					},
                    					defaultType : 'textfieldbase',
					                    rowspan : 5,
					                    title : HreRem.i18n('title.presidente.comunidad.propietarios'),
					                    items : [
					                    			{
                          							  fieldLabel : HreRem.i18n('fieldlabel.nombre'),
							                          bind : '{activo.nomPresidente}'
							                        }, {
							                          fieldLabel : HreRem.i18n('fieldlabel.telefono'),
							                          vtype: 'telefono',
							                          bind : '{activo.telfPresidente}'
							                        }, {
							                          fieldLabel : HreRem.i18n('fieldlabel.telefono.dos'),
							                          vtype: 'telefono',
							                          bind : '{activo.telfPresidente2}'
							                        }, {
							                          fieldLabel : HreRem.i18n('fieldlabel.email'),
							                          vtype: 'emailCustom',
							                          bind : '{activo.emailPresidente}'
							                        }, {
							                          fieldLabel : HreRem.i18n('fieldlabel.direccion'),
							                          bind : '{activo.dirPresidente}'
							                        },					                        
							                        { 
														xtype:'datefieldbase',
												 		fieldLabel: HreRem.i18n('fieldlabel.desde'),
												 		maxValue: null,
										            	bind:		'{activo.fechaInicioPresidente}',
										            	listeners : {
											            	change: function () {
											            		//Eliminar la fechaHasta e instaurar
											            		//como minValue a su campo el velor de fechaDesde
											            		var me = this;
											            		me.next().reset();
											            		me.next().setMinValue(me.getValue());
											                }
										            	}
													},
													{ 
														xtype:'datefieldbase',
												 		fieldLabel: HreRem.i18n('fieldlabel.hasta'),
												 		minValue: $AC.getCurrentDate(),
												 		maxValue: null,
										            	bind:		'{activo.fechaFinPresidente}'
													
													}
							            ]
                  					}, 
                  					{
                    					xtype : 'fieldset',
					                    height: 360,
					                    margin: '0 10 0 0',
					                    layout : {
					                      type : 'table',
					                      trAttrs : {
					                        height : '45px',
					                        width : '100%'
					                      },
					                      columns : 1,
					                      tableAttrs : {
					                        style : {
					                          width : '100%'
					                        }
					                      }
					                    },
					                    defaultType : 'textfieldbase',
					                    rowspan : 5,
					                    title : HreRem.i18n('title.administrador.comunidad.propietarios'),
					                    items : [
					                    			{
							                          fieldLabel : HreRem.i18n('fieldlabel.nombre'),
							                          bind : '{activo.nomAdministrador}'
							                        }, 
													{
							                          fieldLabel : HreRem.i18n('fieldlabel.telefono'),
							                          vtype: 'telefono',
							                          bind : '{activo.telfAdministrador}'
							                        }, 
							                        {
							                          fieldLabel : HreRem.i18n('fieldlabel.telefono.dos'),
							                          vtype: 'telefono',
							                          bind : '{activo.telfAdministrador2}'
							                        }, 
							                        {
							                          fieldLabel : HreRem.i18n('fieldlabel.email'),
							                          vtype: 'emailCustom',
							                          bind : '{activo.emailAdministrador}'
							                        }, 
							                        {
							                          fieldLabel : HreRem.i18n('fieldlabel.direccion'),
							                          bind : '{activo.dirAdministrador}'
							                        }
							            ]
							            
							            
                  					}, 
                  					{
					                    fieldLabel : HreRem.i18n('fieldlabel.nombre.comunidad.propietarios'),
					                    reference: 'nombreComunidadPropietarios',
					                    allowBlank: false,
					                    bind : '{activo.nombre}'
					                }, 
					                {
					                    fieldLabel : HreRem.i18n('fieldlabel.nif.comunidad.propietarios'),
					                    reference: 'nifComunidadPropietarios',
					                    allowBlank: false,
					                    bind : '{activo.nif}'
					                }, 
					                {
					                    fieldLabel : HreRem.i18n('fieldlabel.direccion.comunidad.propietarios'),
					                    bind : '{activo.direccionComunidad}'
					                },
						            {
			                          xtype : 'fieldset',
			                          height: 120,
			                          margin: '80 10 10 0',
			                          layout : {
			                            type : 'table',
			                            trAttrs : {
			                              height : '45px',
			                              width : '50%'
			                            },
			                            columns : 1,
			                            tableAttrs : {
			                              style : {
			                                width : '50%'
			                              }
			                            }
			                          },
			                          defaultType : 'textfieldbase',
			                          rowspan : 6,
			                          // colspan: 0.5,
			                          title : HreRem.i18n('title.documentacion.disponible'),
			                          items : [	  {
					                                xtype : 'checkboxfieldbase',
					                                fieldLabel : HreRem.i18n('fieldlabel.estatutos'),
					                                bind : '{activo.estatutos}'
					                              },
					                              {
					                                xtype : 'checkboxfieldbase',
					                                fieldLabel : HreRem.i18n('fieldlabel.libro.edificio'),
					                                bind : '{activo.libroEdificio}'
					                              },
					                              {
					                                xtype : 'checkboxfieldbase',
					                                fieldLabel : HreRem.i18n('fieldlabel.certificado.ite'),
					                                bind : '{activo.certificadoIte}'
					                              }
					                  ]
                        			}, 
					                {
					                    xtype : 'textareafieldbase',
					                    colspan: '2',
					                    margin: '10 10 10 0',
					                    fieldLabel : HreRem.i18n('fieldlabel.observaciones.comunidad.propietarios'),
					                    width : '100%',
					                    height : 100,
					                    labelAlign: 'top',
					                    bind : '{activo.observaciones}'
					                }
					    ]
            		}
            		
        ];
		me.addPlugin({ptype: 'lazyitems', items: items });
        me.callParent();

      },
      
      funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		if(!me.disabled) {
			me.lookupController().cargarTabData(me);
		}
  	  }
  });