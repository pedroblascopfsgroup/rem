Ext.define('HreRem.view.activos.detalle.TasacionesActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'tasacionesactivo',    
    scrollable: 'y',
    saveMultiple: true,
    records: ['tasacionBankia', 'tasacion'],
	recordsClass: ['HreRem.model.TasacionBankiaModel', 'HreRem.model.ActivoTasacion'],
	requires: ['HreRem.model.TasacionBankiaModel', 'HreRem.model.ActivoTasacion'],

	listeners: {
    	//boxready:'cargarTabData'
    },
	
    initComponent: function () {
    	
        var me = this;
        me.setTitle(HreRem.i18n('title.tasaciones'));
        var items= [
            {
				xtype:'fieldsettable',
				hidden: true,
				title: HreRem.i18n('title.ultima.tasacion'),
				items :	[
			   				{ 
			   					xtype: 'currencyfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.valor.ultima.tasacion'),
								width:		250,
								bind:		'{valoraciones.importeValorTasacion}',
			                	readOnly: true
							},
						    {
								xtype: 'datefieldbase',
								formatter: 'date("d/m/Y")',
								fieldLabel: HreRem.i18n('fieldlabel.fecha.ultima.tasacion'),
								width:		250,
								bind:		'{valoraciones.fechaValorTasacion}',
								readOnly: true
						    },
						    {
						    	xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.tipo.ultima.tasacion'),
								width:		250,
								bind:		'{valoraciones.tipoTasacionDescripcion}',
								readOnly: true
						    }
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.solicitud.tasacion.bankia'),
				bind: {
					hidden: '{!activo.isCarteraBankia}'
				},
				items :	[
						    {
								xtype: 'datefieldbase',
								formatter: 'date("d/m/Y")',
								fieldLabel: HreRem.i18n('fieldlabel.fecha.ultima.solicitud'),
								width:		250,
								bind:		'{tasacionBankia.fechaSolicitudTasacion}',
								readOnly: true
						    },
						    {
						    	xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.id.ultima.solicitud.bankia'),
								width:		250,
								bind:		'{tasacionBankia.externoID}',
								readOnly: true
						    },
						    {
						    	xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.id.ultima.solicitud.rem'),
								width:		250,
								bind:		'{tasacionBankia.idSolicitudREM}',
								readOnly: true
						    },
						    {
						    	xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.gestor.solicitante'),
								width:		250,
								bind:		'{tasacionBankia.gestorSolicitud}',
								readOnly: true,
								colspan: 2
						    },
						    {
			                	xtype: 'button',
			                	hidden: true,
			                	reference: 'btnSolicitarTasacionBankia',
			                	text: HreRem.i18n('btn.solicitar.tasacion.bankia'),
			                	handler: 'onClickSolicitarTasacionBankia',
			                	bind: {
			                		disabled: '{tasacionBankia.deshabilitarBtnSolicitud}'
			                	},
			                	margin: '0 0 15 0'
			                }
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.historico.tasaciones'),
				items :	[
							{
								xtype: 'gridBaseEditableRow',
								idPrincipal: 'activo.id',
								topBar: true,
								removeButton: false,
			   					cls	: 'panel-base shadow-panel',
			   					bind: {
			   						store: '{storeTasacionesGrid}',
			   						topBar: '{isCarteraHyTOrBFA}',
				   					editOnSelect: '{isCarteraHyTOrBFA}'
			   					},
			   					colspan: 3,
			   					columns: [
			   					    {   text: HreRem.i18n('header.listado.tasacion.id'), 
			   				        	dataIndex: 'id',
			   				        	renderer: function(value){
			   				        		if(isNaN(value)){
			   				        			return '';
			   				        		}
			   				        		return value;
			   				        	},
			   				        	flex:1 
			   				        },
			   				        {   text: HreRem.i18n('header.listado.tasacion.tipoTasacion'),
			   				        	dataIndex: 'tipoTasacionCodigo',
			   				        	editor: {
			   				        		xtype:'comboboxfieldbase',
			   				        		reference: 'comboTipoDescripcionCodigo',
			   				        		bind:{
			   				        			store: '{tipoTasacionStore}'
			   				        		},
											addUxReadOnlyEditFieldPlugin: false,
			   		    					allowBlank: false,
											displayField: 'descripcion',
			   		    					valueField: 'codigo'
			   				        	},
										renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			   					            var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('tipoTasacionStore').findRecord('codigo', value);
			   					            var descripcion;
			   					        	if(!Ext.isEmpty(foundedRecord)) {
			   					        		descripcion = foundedRecord.getData().descripcion;
			   					        	}
			   					        	return descripcion;
			   					        },		   				        	
			   				        	flex:2
			   				        },	
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.importe'),
			   				        	dataIndex: 'importeTasacionFin',
			   				        	renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	},
			   				        	editor: {
			   				        		xtype:'numberfield', 
			   				        		hideTrigger: true,
			   				        		keyNavEnable: false,
			   				        		mouseWheelEnable: false,
			   		    					allowBlank: false	
			   				        	},
			   				        	flex:2 
			   				        },
			   				        {   
			   				        	text: HreRem.i18n('fieldlabel.fecha'),
			   				        	dataIndex:	'fechaValorTasacion',
			   				        	editor: {
			   			                    xtype: 'datefield',
			   		    					allowBlank: false
			   			                },
			   				        	flex:2,
			   				        	formatter: 'date("d/m/Y")'	
			   				        },
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.nomTasadora'),
			   				        	dataIndex:	'nomTasador',
			   				        	editor: {
			   				        		xtype:'textfield',
			   		    					allowBlank: false			   				        		
			   				        	},
			   				        	flex:3
			   				        },
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.ilocalizable'),
			   				        	dataIndex:	'ilocalizable',//
			   				        	renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
				          				  	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboSiNoBoolean').findRecord('codigo', value)
				            				var descripcion;
				        					if(!Ext.isEmpty(foundedRecord)) {
				        						descripcion = foundedRecord.getData().descripcion;
				        					}
				            			return descripcion;
				        				},
			   				        	editor: {
			        						xtype:'combobox',
							        		bind: {
							            		store: '{comboSiNoBoolean}',
							            		value:'{tasacion.ilocalizable}'
							            	},
							            	displayField: 'descripcion',
											valueField: 'codigo'	
			   				        	},
			   				        	flex:3
			   				        },
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.externo.bbva'),
			   				        	dataIndex:	'externoBbva',
			   				        	editor: {
			   				        		xtype:'textfield'			   				        		
			   				        	},
			   				        	flex:3
			   				        },
			   				        {
                                        xtype: 'actioncolumn',
                                        text: HreRem.i18n('fieldlabel.gasto.asociado'),
                                        dataIndex: 'numGastoHaya',
                                        items: [{
                                            tooltip: HreRem.i18n('tooltip.ver.gasto'),
                                            getClass: function(v, metadata, record ) {
                                                if (!Ext.isEmpty(record.get("numGastoHaya"))) {
                                                    return 'fa fa-money blue-medium-color';
                                                }
                                            },
                                            handler: 'onClickAbrirGastoTasacion'
                                        }],
                                        renderer: function(value, metadata, record) {
                                            if(Ext.isEmpty(record.get("numGastoHaya"))) {
                                                return "";
                                            } else {
                                                return '<div style="display:inline; margin-left: 10px; margin-right: 30px; font-size: 11px;">'+ value+'</div>'
                                            }
                                        },
                                        flex     : 3,
                                        menuDisabled: true,
                                        hideable: false
                                    }
							    	        
			   				    ],
			   				    dockedItems : [
			   				        {
			   				            xtype: 'pagingtoolbar',
			   				            dock: 'bottom',
			   				            displayInfo: true,
			   				            bind: {
			   				                store: '{storeTasacionesGrid}'
			   				            }
			   				        }
			   				    ],
			   				    listeners: {
									rowclick: 'onTasacionListClick'
								}			   					    
							}
				
				]
            },           
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.detail.tasacion'),
				reference: 'detalleTasacion',
				items :	[
								     				        				    
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaTasacion'),
						width:		250,
						bind:		'{tasacion.fechaValorTasacion}',
						readOnly: true
					},
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaSolTasacion'),
						width:		250,
						bind:		'{tasacion.fechaSolicitudTasacion}',
						readOnly: true
					},
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaRecepcionTasacion'),
						width:		250,
						bind:		'{tasacion.fechaRecepcionTasacion}',
						readOnly: true
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.codFirmaTasadora'),
						width:		250,
						bind:		'{tasacion.codigoFirma}',
						readOnly: true
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.nomTasador'),
						width:		250,
						bind:		'{tasacion.nomTasador}',
						readOnly: true
					},
					{
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorTasacion'),
						width:		250,
						bind:		'{tasacion.importeValorTasacion}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeTasacionFin'),
						width:		250,
						bind:		'{tasacion.importeTasacionFin}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeRepoNetoActual'),
						width:		250,
						bind:		'{tasacion.costeRepoNetoActual}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeRepoNetoFin'),
						width:		250,
						bind:		'{tasacion.costeRepoNetoFinalizado}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefMercadoEstado'),
						width:		250,
						bind:		'{tasacion.coeficienteMercadoEstado}',
						readOnly: true
					},	       				     
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefMercadoEstadoHom'),
						width:		250,
						bind:		'',
						readOnly: true
					},
					{
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefPondValorAnadido'),
						width:		250,
						bind:		'{tasacion.coeficientePondValorAnanyadido}',
						readOnly: true
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.tipoTasacion'),
						width:		250,
						bind:		'{tasacion.tipoTasacionDescripcion}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.valorReperSueloConst'),
						width:		250,
						bind:		'{tasacion.valorReperSueloConst}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeConstConstruido'),
						width:		250,
						bind:		'{tasacion.costeConstConstruido}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceDepreciacionFisica'),
						width:		250,
						bind:		'{tasacion.indiceDepreFisica}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceDepreciacionFuncional'),
						width:		250,
						bind:		'{tasacion.indiceDepreFuncional}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceTotalDepreciacion'),
						width:		250,
						bind:		'{tasacion.indiceTotalDepre}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeConstruccionDepreciada'),
						width:		250,
						bind:		'{tasacion.costeConstDepreciada}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeUnitarioRepoNeto'),
						width:		250,
						bind:		'{tasacion.costeUnitarioRepoNeto}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeReposicion'),
						width:		250,
						bind:		'{tasacion.costeReposicion}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.porcentajeObra'),
						width:		250,
						bind:		'{tasacion.porcentajeObra}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorTerminado'),
						width:		250,
						bind:		'{tasacion.importeValorTerminado}',
						readOnly: true
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.identifTextoAsociado'),
						width:		250,
						bind:		'{tasacion.idTextoAsociado}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorLegalFinca'),
						width:		250,
						bind:		'{tasacion.importeValorLegalFinca}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorSolar'),
						width:		250,
						bind:		'{tasacion.importeValorSolar}',
						readOnly: true
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
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
   }
    
});