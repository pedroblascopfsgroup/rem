Ext.define('HreRem.view.activos.detalle.TasacionesActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'tasacionesactivo',    
    scrollable: 'y',
    saveMultiple: true,
    records: ['tasacionBankia', 'tasacion'],
	recordsClass: ['HreRem.model.TasacionBankiaModel', 'HreRem.model.ActivoTasacion'],
	requires: ['HreRem.model.TasacionBankiaModel', 'HreRem.model.ActivoTasacion'],
    refreshAfterSave: true,
	listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    	}
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
            },
            {
				xtype: 'fieldsettable',
				title: HreRem.i18n('fieldlabel.titulo.datos.basicos.tasacion'),
				reference: 'datosBasicosTasacion',
				bind: {
					hidden: '{!activo.isCarteraTitulizada}'
				},
				colspan: 3,
				items :	[		     				        				    
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.empresa.tasadora'),
						maxLength: 10,
						bind:		'{tasacion.nomTasador}'
					},
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						maxValue: null,
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.fecha'),
						readOnly: true,
						bind:		'{tasacion.fechaValorTasacion}'
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.importe.integro'),
						bind:		'{tasacion.importeTasacionFin}'
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.referencia.id.tasadora'),
						maxLength: 20,
						bind:		'{tasacion.referenciaTasadora}'
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.tipo.valoracion.estado.tasacion'),					
						reference: 'tipoValoracionEstadoTasacion',
				        bind: {
			            	store: '{tipoTasacionStore}',
			            	value: '{tasacion.tipoTasacionCodigo}'
			           	}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.acogida.normativa'),
						bind: {
							store: '{comboSinSino}',
							value: '{tasacion.acogidaNormativa}'
						}		
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.valor.hipotesis.edificio.terminado'),
						bind:		'{tasacion.valorHipotesisEdificioTerminadoPromocion}'
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.advertencias'),
						bind: {
							store: '{comboSinSino}',
							value: '{tasacion.advertencias}'
						}
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.codigo.sociedad.tasacion.valoracion'),
						maxLength: 10,
						bind:		'{tasacion.codigoSociedadTasacionValoracion}'
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.condicionantes'),
						bind: {
							store: '{comboSinSino}',
							value: '{tasacion.condicionantes}'
						}
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.metodo.valoracion'),					
						reference: 'metodoValoracion',
				        bind: {
			            	store: '{comboMetodoValoracion}',
			            	value: '{tasacion.metodoValoracionCodigo}'
			           	}
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.valor.terreno'),
						bind:		'{tasacion.valorTerreno}'
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.valor.terreno.ajustado'),
						bind:		'{tasacion.valorTerrenoAjustado}'
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.valor.hipotesis.edificio.terminado'),
						bind:		'{tasacion.valorHipotesisEdificioTerminado}'
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.valor.hipotecario'),
						bind:		'{tasacion.valorHipotecario}'
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.datos.basicos.tasacion.visita.interior.inmueble'),
						bind: {
							store: '{comboSinSino}',
							value: '{tasacion.visitaAnteriorInmueble}'
						}
					}
				]
    		},
    		{
				xtype: 'fieldsettable',
				title: HreRem.i18n('fieldlabel.titulo.parametros.tasacion'),
				reference: 'parametrosTasacion',
				bind: {
					hidden: '{!activo.isCarteraTitulizada}'
				},
				colspan: 3,
				items :	[
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.superficie.adoptada'),
						bind:		'{tasacion.superficieAdoptada}'
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.superficie.parcela.m2'),
						maxLength: 6,
						readOnly: true,
						bind:		'{tasacion.superficieParcela}'
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.superficie.m2'),
						maxLength: 10,
						readOnly: true,
						bind:		'{tasacion.superficie}'
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.coste.estimado.terminar.obra'),
						bind:		'{tasacion.costeEstimadoTerminarObra}'
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.coste.destinado.uso.propio'),
						bind:		'{tasacion.costeDestinaUsoPropio}'
					},
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						maxValue: null,
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.coste.fecha.estimada.terminar.obra'),
						bind:		'{tasacion.fechaEstimadaTerminarObra}'						
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.plazo.finalizar.comercializacion'),
						maxLength: 3,
						bind:		'{tasacion.mrdPlazoMaximoFinalizarComercializacion}'
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.plazo.finalizar.construccion'),
						maxLength: 3,
						bind:		'{tasacion.mrdPlazoMaximoFinalizarConstruccion}'
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.tasa.anualizada.homogenea'),
						maskRe: /[0-9.]/,
						bind:		'{tasacion.mrdTasaAnualizadaHomogenea}',
	                	validator: function(v) {
                        	if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
                            	return false;
                        	}
                            return true;
                        }
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.tipo.actualizacion'),
						maskRe: /[0-9.]/,
						bind:		'{tasacion.mrdTasaActualizacion}',
	                	validator: function(v) {
                        	if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
                            	return false;
                        	}
                            return true;
                        }
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.margen.beneficio.promotor'),
						maskRe: /[0-9.]/,
						bind:		'{tasacion.mreMargenBeneficioPromotor}',
	                	validator: function(v) {
                        	if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
                            	return false;
                        	}
                            return true;
                        }
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.superficie.terreno.m2'),
						bind:		'{tasacion.superficieTerreno}'
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.parametros.tasacion.tasa.anual.variacion.precio.activo'),
						maskRe: /[0-9.]/,
						bind:		'{tasacion.tasaAnualMedioVariacionPrecioMercado}',
	                	validator: function(v) {
                        	if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
                            	return false;
                        	}
                            return true;
                        }
					}
				]
    		},
    		{
				xtype: 'fieldsettable',
				title: HreRem.i18n('fieldlabel.titulo.planteamiento.tasacion'),
				reference: 'planteamientoTasacion',
				bind: {
					hidden: '{!activo.isCarteraTitulizada}'
				},
				colspan: 3,
				items :	[
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.aprovechamiento.parcela'),
						bind:		'{tasacion.aprovechamientoParcelaSuelo}'
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.desarrollo.planteamiento'),					
						reference: 'desarrolloPlanteamiento',
				        bind: {
			            	store: '{comboDesarrolloPlanteamiento}',
			            	value: '{tasacion.desarrolloPlanteamientoCodigo}'
			           	}
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.fase.gestion'),					
						reference: 'faseGestion',
				        bind: {
			            	store: '{comboFaseGestion}',
			            	value: '{tasacion.faseGestionCodigo}'
			           	}
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.numero.viviendas'),
						maxLength: 3,
						bind:		'{tasacion.numeroViviendas}'
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.porcentaje.ambito.valorado'),
						maskRe: /[0-9.]/,
						bind:		'{tasacion.porcentajeAmbitoValorado}',
	                	validator: function(v) {
                        	if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
                            	return false;
                        	}
                            return true;
                        }
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.producto.desarrollar'),					
						reference: 'productoDesarrollar',
				        bind: {
			            	store: '{comboProductoDesarrollar}',
			            	value: '{tasacion.productoDesarrollarCodigo}'
			           	}
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.proximidad.respecto.nucleo.urbano'),					
						reference: 'proximidadRespectoNucleoUrbano',
				        bind: {
			            	store: '{comboProximidadRespectoNucleoUrbano}',
			            	value: '{tasacion.proximidadRespectoNucleoUrbanoCodigo}'
			           	}
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.sistema.gestion'),					
						reference: 'sistemaGestion',
				        bind: {
			            	store: '{comboSistemaGestion}',
			            	value: '{tasacion.sistemaGestionCodigo}'
			           	}
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.tipo.suelo'),					
						reference: 'tipoSuelo',
				        bind: {
			            	store: '{comboTipoSuelo}',
			            	value: '{tasacion.tipoSueloCodigo}'
			           	}
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.aprovechamiento.m2'),
						bind:		'{tasacion.aprovechamiento}'
					},
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						maxValue: null,
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.fecha.ultimo.grado.avance.estimado'),
						bind:		'{tasacion.fechaUltimoGradoAvanceEstimado}'						
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.porcentaje.urbanicacion.ejecutado'),
						maskRe: /[0-9.]/,
						bind:		'{tasacion.porcentajeUrbanizacionEjecutado}',
	                	validator: function(v) {
                        	if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
                            	return false;
                        	}
                            return true;
                        }
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.porcentaje.ambito.valorado'),
						maskRe: /[0-9.]/,
						bind:		'{tasacion.porcentajeAmbitoValoradoEntero}',
	                	validator: function(v) {
                        	if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
                            	return false;
                        	}
                            return true;
                        }
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.producto.prevee.desarrollar'),					
						reference: 'sistemaGestion',
				        bind: {
			            	store: '{comboProductoDesarrollarPrevisto}',
			            	value: '{tasacion.productoDesarrollarPrevistoCodigo}'
			           	}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.planteamiento.tasacion.producto.proyecto.obra'),
						bind: {
							store: '{comboSinSino}',
							value: '{tasacion.proyectoObra}'
						}
					}
				]
    		},
    		{
				xtype: 'fieldsettable',
				title: HreRem.i18n('fieldlabel.titulo.otras.variables.tasacion'),
				reference: 'otrasVariablesTasacion',
				bind: {
					hidden: '{!activo.isCarteraTitulizada}'
				},
				colspan: 3,
				items :	[
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.otras.variables.tasacion.gasto.comercializacion.tasacion'),
						bind:		'{tasacion.gastosComercialesTasacion}'
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.otras.variables.tasacion.flag.coste.por.defecto'),
						bind: {
							store: '{comboSinSino}',
							value: '{tasacion.porcentajeCosteDefecto}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.otras.variables.tasacion.finca.rustica.expectativas.urbanisticas'),
						bind: {
							store: '{comboSinSino}',
							value: '{tasacion.fincaRusticaExpectativasUrbanisticas}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.otras.variables.tasacion.paralizacion.urbanizacion'),
						bind: {
							store: '{comboSinSino}',
							value: '{tasacion.paralizacionUrbanizacion}'
						}
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.otras.variables.tasacion.tipo.datos.utilizados.inmuebles.comparables'),					
						reference: 'tipoDatoUtilizadoInmuebleComparable',
				        bind: {
			            	store: '{comboTipoDatoUtilizadoInmuebleComparable}',
			            	value: '{tasacion.tipoDatoUtilizadoInmuebleComparableCodigo}'
			           	}
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