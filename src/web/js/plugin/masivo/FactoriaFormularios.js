Ext.ns("es.pfs.plugins.masivo");
//"store":this.dsPlazas
//"store":app.plazas
var codigoPlaza = "01-001";

es.pfs.plugins.masivo.FactoriaFormularios = Ext.extend(Object,{  //Step 1  
    
	attrb: "att1",  
	formulario: "form",
	arrayCampos: [],
	idAsunto:"",
	idProcedimiento:"",
//	dsPlazas:{},
	dsProcedimiento:{},
	storeRequerimientos:{},
	storeMotivosInadmision:{},
	storeMotivosArchivo:{},
	storeDemandados:{},
	storeDomicilios:{},
	storeBienes:{},
	dsJuzgado:{},
	dsDatosAdicionales:{},
	codigoProcedimiento:"",
	idFactoria: "",
    
    constructor : function(options){    //Step 2  
    	Date.now = Date.now || function() { return +new Date; };
    	Ext.apply(this,options || {idFactoria: Date.now(), arrayCampos: []});
        this.initArrays(this.idFactoria);
    },
    

    updateStores: function(){
//    	this.dsPlazas.load({params:{idFactoria:this.idFactoria, dsProcedimiento:this.dsProcedimiento}});    	
    	this.dsProcedimiento.load({params:{idFactoria:this.idFactoria, idProcedimiento:this.idProcedimiento}});
    	this.storeRequerimientos.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivosInadmision.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivosArchivo.load({params:{idFactoria:this.idFactoria}});
    	this.storeDemandados.load({params:{idProcedimiento:this.idProcedimiento, idFactoria:this.idFactoria}});
    	this.dsDatosAdicionales.load({params:{idProcedimiento:this.idProcedimiento}});
    },
    
    getFormItems: function(idTipoResolucion, idAsunto, codigoProcedimiento, codPlaza,idProcedimiento){
    	this.idAsunto=idAsunto;
    	this.codigoProcedimiento=codigoProcedimiento;
    	codigoPlaza=codPlaza;
    	this.idProcedimiento=idProcedimiento;
    	   	
    	var campos = this.arrayCampos[idTipoResolucion];
    	
    	var dinamicElementsLeft = [];
    	var dinamicElementsRight = [];
    	
    	for (var i=0;i<campos.length;i++)
    	{ 	var campo=campos[i];
    		
    		if (i%2 == 0)
    			dinamicElementsLeft.push(campo);
    		else
    			dinamicElementsRight.push(campo);
    	}
    	
    	var dinamicElementsLeft2 = {width:400,items:dinamicElementsLeft};
    	var dinamicElementsRight2 = {width:400,items:dinamicElementsRight}; 

    	var items = [{colspan:2, width:800, style:'padding-top:0px;padding-bottom:0px',
    					items:[{"xtype":'textfield',"name":"d_numAutos","fieldLabel":"N&uacute;mero de autos",allowBlank:function(idTipoResolucion){idTipoResolucion==1 || idTipoResolucion==92 || idTipoResolucion==135},
    						id:'d_numAutos_id' + this.idFactoria
    						,validator : function(v) {
    							if (idTipoResolucion==1 || idTipoResolucion==92 || idTipoResolucion==135){
    								return true;
    							}else {
    								return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
    							}
    						}
						 }]
						}
    	             ,dinamicElementsLeft2
    	             ,dinamicElementsRight2
			         ,{colspan:2, width:800, style:'padding-top:0px;padding-bottom:0px',
						items:[ {"xtype":'displayfield',"name":"textoInformativo","fieldLabel":"","value":"",allowBlank:true,width:600, hidden:true}]
						}    	             
    	             ,{colspan:2, width:800, style:'padding-top:0px;padding-bottom:0px',
    						items:[ {"xtype":'textarea',"name":"d_observaciones","fieldLabel":"Observaciones",allowBlank:true,width:600}]
						}
				        ,{colspan:2, width:800, style:'padding-top:0px;padding-bottom:0px',
							items:[ {"xtype":'displayfield',"name":"file","fieldLabel":"Fichero","value":"No se ha adjuntado ning&uacute;n fichero.",allowBlank:true,width:400}]
						}
    	]; 
    	return items;
    	
    },
    
    /** private **/
    getTextField: function(name,fieldLabel){
    	return {
    			xtype: 'textfield'
    			,name: name
    			,fieldLabel: fieldLabel
    			}
    	
    }, 
    	
    /** private **/
    initArrays: function(idFactoria){
    	var fechaMinima = '01/01/1900';
    	// cargar plazas
//    	var plazasRecord = Ext.data.Record.create([
//    	                                        	 {name:'id'}
//    	                                        	,{name:'codigo'}
//													,{name:'descripcion'}
//													 ]);
//    	
//    	this.dsPlazas = new Ext.data.Store({
//    		url:'/pfs/msvprocesadoresoluciones/getPlazas.htm'
//    		,reader: new Ext.data.JsonReader({
//    			root : 'plazas'
//    		} , plazasRecord)
//    	});

    	
    	if (app.plazas == undefined) {
    		
    		var plazasRecordGlobal = Ext.data.Record.create([
    	    	                                        	 {name:'id'}
    	    	                                        	,{name:'codigo'}
    														,{name:'descripcion'}
    														 ]);
    		
    		app.plazas = new Ext.data.Store({
    	    		url:'/pfs/msvprocesadoresoluciones/getPlazas.htm'
    	    		,reader: new Ext.data.JsonReader({
    	    			root : 'plazas'
    	    		} , plazasRecordGlobal)
    	    	});

    		app.plazas.load();
    	}
    	
    	var procedimientoRecord = Ext.data.Record.create([
  	                                        	 {name:'id'}
  	                                        	,{name:'tipoProcedimiento'}
												,{name:'numeroAutos'}
												,{name:'demandado'}
												,{name:'importe'}
												,{name:'codigoPlaza'}
												,{name:'codigoJuzgado'}
												]);
  	
    	this.dsProcedimiento = new Ext.data.Store({
    		url:'/pfs/msvprocesadoresoluciones/getProcedimiento.htm'
    			,reader: new Ext.data.JsonReader({
    				root : 'procedimiento'
    			} , procedimientoRecord)
    	});
    	// cargar juzgados
    	var juzgadosRecord = Ext.data.Record.create([{name:'id'}
    	                                        	,{name:'codigo'}
													,{name:'descripcion'}
													 ]);
    	
    	this.dsJuzgado = new Ext.data.Store({
    		id:'dsJuzgado'
    		,url:'/pfs/msvprocesadoresoluciones/getJuzgadosByPlaza.htm'
    		,reader: new Ext.data.JsonReader({
    			root : 'juzgados'
    		} , juzgadosRecord)
    	});
    	
    	// tipos de requerimientos
    	var tipoRequerimientoRecord = Ext.data.Record.create([
    	    	                                        	{name:'codigo'}
    														,{name:'descripcion'}
    														 ]);
    	this.storeRequerimientos= new Ext.data.Store({
    		url:'/pfs/msvprocesadoresoluciones/getTiposRequerimiento.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'requerimientos'
        		} , tipoRequerimientoRecord)
        	});
    	
    	// motivos de inadmision 
    	var motivosRecord = Ext.data.Record.create([
      	    	                                        	{name:'codigo'}
      														,{name:'descripcion'}
      														 ]);
    	this.storeMotivosInadmision= new Ext.data.Store({
    		url:'/pfs/msvprocesadoresoluciones/getMotivosInadmision.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'motivos'
        		} , motivosRecord)
        	});
    	
    	var motivosArchivoRecord = Ext.data.Record.create([
	    	                                        	{name:'codigo'}
														,{name:'descripcion'}
														 ]);
    	
    	this.storeMotivosArchivo= new Ext.data.Store({
    		url:'/pfs/msvprocesadoresoluciones/getMotivosArchivo.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'motivos'
        		} , motivosArchivoRecord)
        	});
    	
    	
    	
    	// demandados
    	var demandadosRecord = Ext.data.Record.create([
      	    	                                        	{name:'id'}
      														,{name:'codigo'}
      														 ]);
    	this.storeDemandados= new Ext.data.Store({
    		url:'/pfs/msvprocesadoresoluciones/getDemandadosProcedimiento.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'demandados'
        		} , demandadosRecord)
        	});
    	
    	// domicilios demandados
    	var domiciliosRecord = Ext.data.Record.create([
      	    	                                        	{name:'id'}
      														,{name:'codigo'}
      														 ]);
    	this.storeDomicilios= new Ext.data.Store({
    		url:'/pfs/msvprocesadoresoluciones/getDomiciliosDemandados.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'domicilios'
        		} , domiciliosRecord)
        	});
    	
    	// bienes de demandados
    	var bienesRecord = Ext.data.Record.create([
 	    	                                        	{name:'id'}
 														,{name:'codigo'}
 														 ]);
    	this.storeBienes= new Ext.data.Store({
    		url:'/pfs/msvprocesadoresoluciones/getBienesDemandado.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'bienes'
        		} , bienesRecord)
        	});
    	
    	var datosAdicionalesRecord = Ext.data.Record.create([
    	                                                     {name : 'conTestimonio'} 
    	                                                    ]);

		this.dsDatosAdicionales = new Ext.data.Store({
					url : '/pfs/msvprocesadoresoluciones/getDatosAdicionales.htm'
						,reader : new Ext.data.JsonReader({
							root : 'datosAdicionales'
						}, datosAdicionalesRecord)
				});
    	
//    	this.dsPlazas.on('load', function(combo, r, options){    			
//        	debugger;
//        });
    	
    	refrescaComboPlaza = function(options){
    		var plazas=Ext.getCmp('d_plaza_id' + options.params.idFactoria);
    		if (plazas!='' && plazas!=null && options.params.dsProcedimiento.getAt(0)!=undefined) {
    			if ((plazas.getValue()=='' || plazas.getValue()==null) && options.params.dsProcedimiento.getAt(0).get('codigoPlaza')!='' && options.params.dsProcedimiento.getAt(0).get('codigoPlaza')!=null){
        			codigoPlaza =options.params.dsProcedimiento.getAt(0).get('codigoPlaza');
        		}
    			plazas.setValue(codigoPlaza);
    			var juzgado=Ext.getCmp('d_juzgado_id' + options.params.idFactoria);
        		if (juzgado!='' && juzgado!=null){
        			storeJuzgado=juzgado.getStore();
        			storeJuzgado.purgeListeners();
        			storeJuzgado.load({params:{codigoPlaza:plazas.getValue(), idFactoria:this.idFactoria}});
    				storeJuzgado.on('load', function(){
    					if ((juzgado.getValue()=='' || juzgado.getValue()==null) && options.params.dsProcedimiento.getAt(0).get('codigoJuzgado')!='' && options.params.dsProcedimiento.getAt(0).get('codigoJuzgado')!=null){
    						juzgado.setValue(options.params.dsProcedimiento.getAt(0).get('codigoJuzgado'));
    	        		} else {
    	        			juzgado.setValue(juzgado.getValue());
    	        		}
    					
    				});
        		}	
    		}
    	};
    	
    	this.dsProcedimiento.on('load', function(store, r, options){
    		var numAutos =Ext.getCmp('d_numAutos_id' + options.params.idFactoria);
    		if (numAutos!='' && numAutos!=null){
    			if (numAutos.getValue()=='' || numAutos.getValue()==null){
    				if (store.getAt(0).get('numeroAutos')!='' && store.getAt(0).get('numeroAutos')!=null){
    					numAutos.setValue(store.getAt(0).get('numeroAutos'));
        				numAutos.setReadOnly(true);
        				numAutos.el.setStyle('background-image:none; background-color: #CCCCCC;');
    				}
    			}
    			if (store.getAt(0).get('tipoProcedimiento')=='P71' ){
        			numAutos.setVisible(false);
        			numAutos.validator=true;
        			numAutos.allowBlank=true;
        		}
    		}
    		var numAutosVerbal =Ext.getCmp('d_numAutos_verbal_id' + options.params.idFactoria);
    		if (numAutosVerbal!='' && numAutosVerbal!=null){
    			if (store.getAt(0).get('tipoProcedimiento')=='P70' && store.getAt(0).get('importe')<6000){
	    			numAutosVerbal.setVisible(true);
	    			numAutosVerbal.validator=function(v) {
					    	return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : '<s:message code="genericForm.validacionProcedimiento" text="**Debe introducir un número con formato xxxxx/xxxx" />';
					    	};
	        	} 
    		}
    		
    		
//    		if (store.getAt(0).get('codigoPlaza')!=null && store.getAt(0).get('codigoPlaza')!=''){
//    			codigoPlaza=store.getAt(0).get('codigoPlaza');
//    		}
    		refrescaComboPlaza({params:{idFactoria:options.params.idFactoria, dsProcedimiento:store}})
    	});
    	
    	this.storeRequerimientos.on('load', function(store, r, options){    	
    		var comboRequerimientos=Ext.getCmp('d_tipoRequerimiento_id' + options.params.idFactoria);
    		if (comboRequerimientos!='' && comboRequerimientos!= null){
    			comboRequerimientos.setValue(comboRequerimientos.getValue());
    		}	
        });
    	
    	this.storeMotivosInadmision.on('load', function(store, r, options){
    		var motivosInadmision=Ext.getCmp('d_motivoInadmision_id' + options.params.idFactoria);
    		if (motivosInadmision!='' && motivosInadmision!= null){
    			motivosInadmision.setValue(motivosInadmision.getValue());
    		}	
        });
    	
    	this.storeMotivosArchivo.on('load', function(store, r, options){
    		var motivosArchivo=Ext.getCmp('d_motivoArchivo_id' + options.params.idFactoria);
    		if (motivosArchivo!='' && motivosArchivo!= null){
    			motivosArchivo.setValue(motivosArchivo.getValue());
    		}	
        });
    	
    	
    	
    	this.storeDemandados.on('load', function(store, records, options){
    		//var nombreDemandado=Ext.getCmp('d_nombreDemandado' + options.params.idFactoria );
    		var nombreDemandado=Ext.getCmp('d_nombreDemandado_id' + options.params.idFactoria);
    		//var pt=this.findParentByType(Ext.form.FormPanel).getForm().findField('d_nombreDemandado');
    		var demandadoPrincipalProcedimiento =store.getAt(0).get('codigo');
    		var demandadoProcedimiento= Ext.getCmp('demandadoProcedimiento_id'+ options.params.idFactoria);
    		if (demandadoProcedimiento!='' && demandadoProcedimiento!=null){
    			demandadoProcedimiento.setValue(demandadoPrincipalProcedimiento);
    		}
    		
    		var storeBienes=null;
    		if (nombreDemandado!='' && nombreDemandado!= null){
    			var domicilios = Ext.getCmp('d_domicilioDemandado_id' + options.params.idFactoria);
    			bienes = Ext.getCmp('d_bienesDemandado_id' + options.params.idFactoria);
    			nombreDemandado.setValue(nombreDemandado.getValue());
    			if (nombreDemandado.getValue()!= '' && nombreDemandado.getValue()!=null){
	    			if (domicilios!='' && domicilios!=null){
	    				var storeDomicilios=domicilios.getStore();
	    				storeDomicilios.purgeListeners();
	    				storeDomicilios.load({params:{idDemandado:nombreDemandado.getValue(), idFactoria:this.idFactoria}});
	    				storeDomicilios.on('load', function(){
	    					domicilios.setValue(domicilios.getValue());
	    				});
	    			}
	    			if (bienes!='' && bienes!=null){
	    				storeBienes=bienes.getStore();
	    				storeBienes.purgeListeners();
	    				storeBienes.load({params:{idDemandado:nombreDemandado.getValue(), idFactoria:this.idFactoria}});
	    				storeBienes.on('load', function(){
	    					bienes.setValue(bienes.getValue());
	    				});
	    			}
    			}	
    		}	
        });

    	this.dsDatosAdicionales.on('load', function(store, r, options) {

			var conTestimonio = Ext.getCmp('d_contratoRecibido_id');
			if (conTestimonio != '' && conTestimonio != null && store.getAt(0).get('conTestimonio') != '' ) {
				var valor = "";
				if(store.getAt(0).get('conTestimonio') == "S"){
					valor = "SI"
				}else if(store.getAt(0).get('conTestimonio') == "N"){
					valor = "NO"
				}
				conTestimonio.setValue(valor);
				conTestimonio.setReadOnly(true);
			}
		});
    	
    	var fn_handler_button = function(){
			var pt=this.findParentByType(Ext.form.FormPanel).getForm().findField('idProcedimiento');
			var w = app.openWindow({
				text:'Notificaci&oacute;n Demandados'
				,flow: 'msvnotificaciondemandados/abreVentanaNotificacion'
				,width:910
				,title: 'Notificacion Demandados'
				,layout: 'form'
				,closable: true
				,params:{
					idProcedimiento:pt.getValue()
				}					
			});
			w.on(app.event.DONE, function(){
				w.close();
				//entidad.refrescar();
			});
			w.on(app.event.CANCEL, function(){ 
				w.close(); 
			});			
		};
    	//id:0
    	this.arrayCampos.push([]);
    	//id:1 Mon: Demanda presentada
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecPresentacionDemanda","fieldLabel":"Fecha Presentaci&oacute;n Demanda","format":"d/m/Y",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    						 ,{"xtype":'datefield',"name":"d_fecRecepPresentacionDemanda","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    						 ]);
    	//id:2 Mon: Inadmisión de la demanda
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionInadmision","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    							,{"xtype":'datefield',"name":"d_fecRecepResolInadmision","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    							,{"xtype":'combo',"editable":"false","store":this.storeMotivosInadmision, width:'250', mode:'local', "name":"d_motivoInadmision","hiddenName":"d_motivoInadmision", id:'d_motivoInadmision_id' + this.idFactoria,"fieldLabel":"Motivo Inadmisi&oacute;n",triggerAction: 'all',allowBlank:true,displayField:'descripcion',valueField:'codigo', "autoload":true }
    							,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true}
    							,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
    								,autoSelect :true ,displayField:'descripcion',valueField:'codigo', "autoload":true
    								, listeners:{select :function(combo){
    									var idFactoria = combo.id.replace('d_plaza_id','');
    									var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
    									var storeJuzgado= juzgado.getStore();
    									storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
									}
    								}}
       						 	,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado", "hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
       						 	]);
    	//id:3 Mon: Requerimientos previos
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionReqPrevAdmitido","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    							,{"xtype":'datefield',"name":"d_fecRecepResolReqPrev","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    							,{"xtype":'combo',"editable":"false","store":this.storeRequerimientos ,mode:'local', "name":"d_tipoRequerimiento","hiddenName":"d_tipoRequerimiento",id:'d_tipoRequerimiento_id' + this.idFactoria
    								,"fieldLabel":"Tipo de Requerimiento",triggerAction: 'all',allowBlank:true,displayField:'descripcion',valueField:'codigo', "autoload":true }
    							,{"xtype":'numberfield',"name":"d_plazoResolucion","fieldLabel":"Plazo para solventar requerimiento",allowBlank:false }
    							,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza", "hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
    								,displayField:'descripcion',valueField:'codigo', "autoload":true
    								, listeners:{select :function(combo){
    									var idFactoria = combo.id.replace('d_plaza_id','');
    									var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
    									var storeJuzgado= juzgado.getStore();
    									storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
									}
    								}}
    							,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado","hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
       						 	]);
    	//id:4 Mon: Admisión de la demanda
    	// juntamos las dos admisiones en una y le ponemos un tipo de admisión
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDemanda","fieldLabel":"Fecha de admisi&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    							,{"xtype":'datefield',"name":"d_fecRecepResolDemanda","fieldLabel":"Fecha recepci&oacute;n demanda",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    							,{"xtype":'combo',"store":["Total","Parcial"],"editable":"false",mode:'local', "name":"d_demandaTotal", "hiddenName":"d_demandaTotal","fieldLabel":"Total / Parcial",triggerAction: 'all',allowBlank:true, id:'d_demandaTotal_id'+this.idFactoria
									, listeners:{select:function(combo){
										var idFactoria = combo.id.replace('d_demandaTotal_id','');
										var plazoImpugnacionAdmmision=Ext.getCmp('d_plazoImpugnacion'+idFactoria);
										if(combo.getValue()=='Parcial'){
											plazoImpugnacionAdmmision.setVisible(true);
											}
										else{
											plazoImpugnacionAdmmision.setVisible(false);
										}
									}
								}
    							}
    							,{"xtype":'numberfield',"name":"d_cuantiaDemandada","fieldLabel":"Cuant&iacute;a demandada",allowBlank:false }
    							,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
    								,displayField:'descripcion',valueField:'codigo', "autoload":true
    								, listeners:{select :function(combo){
    									var idFactoria = combo.id.replace('d_plaza_id','');
    									var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
    									var storeJuzgado= juzgado.getStore();
    									storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
    									//juzgado.setValue(juzgado.getValue());	
									}
    								}}
    							,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado","hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
       						 	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",hidden:true, allowBlank:true, id:"d_plazoImpugnacion"+this.idFactoria}
       						 	]);
    	//id:5 Mon: Requerimiento de pago 
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionReqPago","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                        ,{"xtype":'datefield',"name":"d_fecRecepResolReqPago","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                        ,{"xtype":'button',"name":"botonNotificacion",text : 'Introduzca los datos de notificaci&oacute;n a los demandados' ,iconCls : 'icon_busquedas'
    	            					,handler : fn_handler_button
    	                        }
//    	                        ,this.botonAccesoNotificacion
//    	                        ,{"xtype":'combo',"store":["Positivo","Negativo"],"editable":"false",mode:'local', "name":"d_resultadoPositivo","hiddenName":"d_resultadoPositivo","fieldLabel":"Positivo / Negativo",triggerAction: 'all',allowBlank:true }
//    	                        ,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria, "fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:false
//    	                        	,displayField:'codigo',valueField:'id', "autoload":true
//    								, listeners:{select :function(combo){
//    									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
//    									var storeDomicilios= Ext.getCmp('d_domicilioDemandado_id' + idFactoria).getStore();
//    									storeDomicilios.load({params:{idDemandado:combo.getValue()}});
//									}
//    								}}
//    	                        ,{"xtype":'numberfield',"name":"d_hidden","fieldLabel":"Oculto",allowBlank:true, hidden:true,disabled:true}
//    	                        ,{"xtype":'combo',"store": this.storeDomicilios, width:'350', "name":"d_domicilioDemandado","hiddenName":"d_domicilioDemandado","fieldLabel":"Domicilio",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_domicilioDemandado_id' + this.idFactoria, resizable:true}
  	                        	]);
    	//id:6 Mon:Contestacion Oficios de Localización
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fechaContestacionRequerimiento","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'datefield',"name":"d_fechaRecepContestacionReq","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
//  	                        	,{"xtype":'combo',"store":[["SOLICITUD","Solicitud"] ,["POSITIVO-PRIMER INTENTO", "Positivo"],["NEGATIVO-TOTAL", "Negativo"]]
//  	                        	    ,"editable":"false",mode:'local', "name":"d_tipoOficio","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true 
//  	                        		,resizable:true, hiddenName:'d_tipoOficio', id:'d_tipoOficio_id' + this.idFactoria
//  	                        		, listeners:{select:function(combo) {
//  	                        			var idFactoria = combo.id.replace('d_tipoOficio_id','');
//  	                        			var domicilioDemandadoLocalizacion=Ext.getCmp('d_domicilioDemandado_id' + idFactoria);
//  	                        			if(combo.getValue()=='POSITIVO-PRIMER INTENTO' || combo.getValue()=='POSITIVO-REPETIDO'){
//  	                        				domicilioDemandadoLocalizacion.setVisible(true);
//  	                        			} else {
//  	                        				domicilioDemandadoLocalizacion.setVisible(false);
//  	                        			}
//  	                        		}
//  	                        	}}
  	                        	//,{"xtype":'combo',"store":["Total", "Parcial"],"editable":"false",mode:'local', "name":"d_requerimientoTotal","fieldLabel":"Total/Parcial",triggerAction: 'all',allowBlank:true }
  	                        	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria, "fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true, hiddenName:'d_nombreDemandado'
    	                        	,displayField:'codigo',valueField:'id', "autoload":true
//    								, listeners: {
//    									select :function(combo) {
//    										var idFactoria = combo.id.replace('d_nombreDemandado_id','');
//    										var storeDomicilios= Ext.getCmp('d_domicilioDemandado_id' + idFactoria).getStore();
//    										storeDomicilios.load({params:{idDemandado:combo.getValue()}});
//    									}
//    								}
  	                        	}
  	                        	,{"xtype":'numberfield',"name":"d_hidden","fieldLabel":"Oculto",allowBlank:true, hidden:true,disabled:true}
  	                        	,{"xtype":'button',"name":"botonNotificacion",text : 'Introduzca los datos de notificaci&oacute;n a los demandados' ,iconCls : 'icon_busquedas'
	            					,handler : fn_handler_button
  	                        	}
//  	                        	,{"xtype":'combo',"store": this.storeDomicilios, "name":"d_domicilioDemandado", hiddenName:'d_domicilioDemandado',"fieldLabel":"Domicilio",allowBlank:true ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_domicilioDemandado_id' + this.idFactoria, resizable:true, width:'350'}
  	                        	]);
    	//id:7 Mon: Habilitación horario nocturno
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionRespNoctur","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'datefield',"name":"d_fecRecepResolRespNoctur","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
//  	                        	,{"xtype":'combo',"store":["Solicitud","Aprobada", "Denegada"],"editable":"false",mode:'local', "name":"d_tipoComunicacion","hiddenName":"d_tipoComunicacion","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true 
//  	                        		, listeners:{select:function(combo){
//									var domicilioPlazoImpugnacionHorariosNoct=Ext.getCmp('d_plazoImpugnacionHN');
//									if(combo.getValue()=='Denegada'){
//										domicilioPlazoImpugnacionHorariosNoct.setVisible(true);
//										}
//									else{
//										domicilioPlazoImpugnacionHorariosNoct.setVisible(false);
//										}
//  	                        		}
//  	                        	}}
  	                        	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
  	                        	,{"xtype":'numberfield',"name":"d_hidden","fieldLabel":"Oculto",allowBlank:true, hidden:true,disabled:true}
  	                        	,{"xtype":'button',"name":"botonNotificacion",text : 'Introduzca los datos de notificaci&oacute;n a los demandados' ,iconCls : 'icon_busquedas'
	            					,handler : fn_handler_button
  	                        	}
//  	                        	,{"xtype":'combo',"store": this.storeDomicilios, width:'350', "name":"d_domicilioDemandado","hiddenName":"d_domicilioDemandado","fieldLabel":"Domicilio",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_domicilioDemandado_id' + this.idFactoria, resizable:true}
//  	                        	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, id:'d_plazoImpugnacionHN', hidden:true}
  	                        	]);
    	//id:8 Mon: Consignación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionConsignaTotal","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'datefield',"name":"d_fecRecepResolConsignaTotal","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'combo',"store":["Total", "Parcial"],"editable":"false",mode:'local', "name":"d_tipoConsigna","hiddenName":"d_tipoConsigna","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true,id:'d_tipoConsigna_id'+this.idFactoria
  	                        		, listeners:{select:function(combo){
  	                        		var idFactoria = combo.id.replace('d_tipoConsigna_id','');
									var plazoLiquidacionConsig=Ext.getCmp('d_plazoLiquidacionConsig'+idFactoria);
									if(combo.getValue()=='Total'){
										plazoLiquidacionConsig.setVisible(true);
										}
									else{
										plazoLiquidacionConsig.setVisible(false);
										}
  	                        		}
  	                        	}}
  	                        	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado"
  	                        		,id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandados",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    								}
  	                        	,{"xtype":'numberfield',"name":"d_cuantiaDemandada","fieldLabel":"Cuant&iacute;a",allowBlank:false}
  	                        	,{"xtype":'numberfield',"name":"d_hidden","fieldLabel":"Oculto",allowBlank:true, hidden:true,disabled:true}
  	                        	,{"xtype":'numberfield',"name":"d_plazoLiquidacion","fieldLabel":"Plazo de liquidaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoLiquidacionConsig'+this.idFactoria}
  	                        	]);
    	//id:9 Mon: Solicitud de justicia gratuita
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionSolJustGratuita","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'datefield',"name":"d_fecRecepResolSolJustGratuita","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
  	                        	]);
    	//id:10 Mon: Justicia Gratuita: Designación de profesionales
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionJustGratuitaProvis","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'datefield',"name":"d_fecRecepResolJustGratuitaProvis","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'combo',"store":["Provisional", "Definitivo","Denegada"],"editable":"false",mode:'local', "name":"d_tipoJustGratuita","hiddenName":"d_tipoJustGratuita","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true }
  	                        	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
  	                        	]);
    	//id:11 Mon: Justicia Gratuita: Allanamiento
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAllanaParcial","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
  	                        	,{"xtype":'datefield',"name":"d_fecRecepResolAllanaParcial","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'combo',"store":["Total", "Parcial"],"editable":"false",mode:'local', "name":"d_tipoAllanamiento","hiddenName":"d_tipoAllanamiento","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true }
  	                        	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
  	                        	]);
    	//id:12 Mon: Oposición
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionOposicion","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'datefield',"name":"d_fecRecepResolOposicion","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:false, disabled:false}
  	                        	,{"xtype":'numberfield',"name":"d_hidden","fieldLabel":"Oculto",allowBlank:true, hidden:true,disabled:true}
  	                        	,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, minValue: fechaMinima}
  	                        	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
  	                        	,{"xtype":'textfield',"name":"d_numAutos_verbal","fieldLabel":"N&uacute;mero de autos (verbal)",allowBlank:true, id:'d_numAutos_verbal_id'+ this.idFactoria, hidden:true }
  	                        	]);
    	//id:13 Mon: Oposición: Impugnación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionImpugnaOposicion","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false , maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'datefield',"name":"d_fecRecepResolImpugnaOposicion","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
  	                        	]);
    	
    	//id:14 Mon: Auto Fin de monitorio
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDecretoFinMon","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'datefield',"name":"d_fecRecepResolDecretoFinMon","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
  	                        	,{"xtype":'numberfield',"name":"d_cuantiaDemandada","fieldLabel":"Cantidad Decreto",allowBlank:true, disabled:false}
  	                        	]);
    	
    	//id:15 Mon: Comparecencia del demandado
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionComparecencia","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolComparecencia","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	//,{"xtype":'combo',"store":["Total", "Parcial"],"editable":"false",mode:'local', "name":"d_tipoConsigna","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true }
						      	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
  	                        	]);
    	//id:16 Mon: Archivo
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionArchivo","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolArchivo","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'combo',"editable":"false","store":this.storeMotivosArchivo, width:'250', mode:'local', "name":"d_motivoArchivo","hiddenName":"d_motivoArchivo", id:'d_motivoArchivo_id' + this.idFactoria,"fieldLabel":"Motivo Archivo",triggerAction: 'all',allowBlank:true,displayField:'descripcion',valueField:'codigo', "autoload":true }
						      	,{"xtype":'combo',"store":["Provisional", "Definitivo"],"editable":"false",mode:'local', "name":"d_tipoArchivo","hiddenName":"d_tipoArchivo","fieldLabel":"Tipo archivo",triggerAction: 'all',allowBlank:true }
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, disabled:false}
  	                        	]);
    	//id:17 Mon: Desistimiento
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDesistimiento","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolDesistimiento","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	]);
    	//id:18 Mon: Suspensión
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionSuspension","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false , maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolSuspension","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'combo',"store":[["SUSPENSION","Notificacion"], ["LEVANTAMIENTO","Levantamiento"]],"editable":"false",mode:'local', "name":"d_tipoSuspension","hiddenName":"d_tipoSuspension"
						      		,"fieldLabel":"Tipo suspension",triggerAction: 'all',allowBlank:true,id:'d_tipoSuspension_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoSuspension_id','');
									var plazoImpugnacionSusp=Ext.getCmp('d_plazoImpugnacionSusp'+idFactoria);
									if(combo.getValue()=='SUSPENSION'){
										plazoImpugnacionSusp.setVisible(true);
										}
									else{
										plazoImpugnacionSusp.setVisible(false);
										}
  	                        		}
  	                        	}}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true,hidden:true, id:'d_plazoImpugnacionSusp'+this.idFactoria}   	
						      	]);
    	//id:19 Solicitud impulso procesal
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionImpulso","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolImpulso","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	]);
    	//id:20 Mon: Oficios de Averiguación Patrimonial
    	this.arrayCampos.push([{"xtype":'displayfield',"name":"demandadoProcedimiento","fieldLabel":"Demandado" ,"value":"",allowBlank:true, "hiddenName":"demandadoProcedimiento", id:'demandadoProcedimiento_id' + this.idFactoria}
       							,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
       							,{"xtype":'datefield',"name":"d_fechaPresentacionOfiAverig","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
						      	,{"xtype":'datefield',"name":"d_fechaRecepPresentacionOfAverig","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'combo',"store":["Solicitud", "Positivo", "Negativo"],"editable":"false",mode:'local', "name":"d_tipoAverigPatrim","hiddenName":"d_tipoAverigPatrim"
						      		,id:'d_tipoAverigPatrim_id' + this.idFactoria,"fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		, listeners:{select:function(combo){
						      			var textoInformativo = this.findParentByType(Ext.form.FormPanel).getForm().findField('textoInformativo');
						      			var checks = this.findParentByType(Ext.form.FormPanel).getForm().findField('checksTramite');
						      			textoInformativo.setValue("Por favor, recuerde que es necesario dar de alta los bienes en la pesta&ntilde;a de bienes del asunto.");
										if(combo.getValue()=='Positivo'){
											textoInformativo.setVisible(true);
											checks.setVisible(true);
											checks.setDisabled(false);
											}
										else{
											textoInformativo.setVisible(false);
											checks.setVisible(false);
											checks.setDisabled(true);
											}
	  	                        		}
	  	                        	}
						      	}
						      	,{
						            xtype: 'checkboxgroup',
						            fieldLabel: 'Lanzar tr&aacute;mites',
						            itemCls: 'x-check-group-alt',
						            columns: 1,
						            hidden: true,
						            name: 'checksTramite',
						            items: [
						                {boxLabel: 'Embargo de Salario', name: 'd_embargoSalario'},
						                {boxLabel: 'Embargo de Bienes', name: 'd_embargoBienes'}
						            ]
						        }						      
						      	]);
    	//id:21 Mon: Contestación de prueba testifical solicitada
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionPruebaTestifical","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false , maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolPruebaTestifical","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'combo',"store":["Aprobada","Denegada"],"editable":"false",mode:'local', "name":"d_tipoPruebaTestifical","hiddenName":"d_tipoPruebaTestifical"
						      		,"fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true,id:'d_tipoPruebaTestifical_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoPruebaTestifical_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionPruebTest'+idFactoria);
									if(combo.getValue()=='Denegada'){
										plazoImpugnacion.setVisible(true);
										}
									else{
										plazoImpugnacion.setVisible(false);
										}
  	                        		}
  	                        	}}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionPruebTest'+this.idFactoria}
  	                        	
						      	]);
    	//id:22 ETJ: Auto despacho ejecución
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAude","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolAude","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'combo',"store":["Total","Parcial"],"editable":"false",mode:'local', "name":"d_tipoAude","hiddenName":"d_tipoAude","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		, id:'d_tipoAude_id' + this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoAude_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionAude'+idFactoria);
									if(combo.getValue()=='Parcial'){
										plazoImpugnacion.setVisible(true);
										}
									else{
										plazoImpugnacion.setVisible(false);
										}
  	                        		}
  	                        	}}
						      	,{"xtype":'numberfield',"name":"d_cuantiaDemandada","fieldLabel":"Cuant&iacute;a demandada",allowBlank:false }
						      	,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
    								,autoSelect :true ,displayField:'descripcion',valueField:'codigo', "autoload":true
    								, listeners:{select :function(combo){
    									var idFactoria = combo.id.replace('d_plaza_id','');
    									var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
    									var storeJuzgado= juzgado.getStore();
    									storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
									}
    								}}
       						 	,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado", "hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionAude' + this.idFactoria}
						      	]);
    	//id :23 ETJ: Requerimiento de notificación por edictos
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionNotEdict","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolNotEdict","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":["Solicitud","Aprobada","Denegada"],"editable":"false",mode:'local', "name":"d_tipoNotEdict", "hiddenName":"d_tipoNotEdict","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		, id:'d_tipoNotEdict_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoNotEdict_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionNotEdic'+this.idFactoria);
									if(combo.getValue()=='Denegada'){
										plazoImpugnacion.setVisible(true);
										}
									else{
										plazoImpugnacion.setVisible(false);
										}
						      		}
						      	}}
						      	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionNotEdic'+this.idFactoria}
						      	]);
    	//id :24 ETJ: Embargo / Mejora embargo EMB
    	this.arrayCampos.push([	{"xtype":'displayfield',"name":"demandadoProcedimiento","fieldLabel":"Demandado" ,"value":"",allowBlank:true, "hiddenName":"demandadoProcedimiento", id:'demandadoProcedimiento_id' + this.idFactoria}
    	                       	,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
    							,{"xtype":'datefield',"name":"d_fecResolucionEmb","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolEmb","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":["Solicitud","Decreto","Denegada"],"editable":"false",mode:'local', "name":"d_tipoEmb","hiddenName":"d_tipoEmb","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		,id:'d_tipoEmb_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoEmb_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionEmb'+this.idFactoria);
									if(combo.getValue()=='Denegada'){
										plazoImpugnacion.setVisible(true);
										}
									else{
										plazoImpugnacion.setVisible(false);
										}
						      		}
						      		, render:function(){
						      			var textoInformativo = this.findParentByType(Ext.form.FormPanel).getForm().findField('textoInformativo');
										textoInformativo.setValue("Por favor, actualice la informaci&oacute;n del embargo a trav&eacute;s de la pesta&ntilde;a de bienes del tr&aacute;mite de embargo.");
										textoInformativo.setVisible(true);
						      		}
						      	}}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionEmb'+this.idFactoria}
						      	]);
    	// id:25 ETJ: Embargo: Anotación
    	this.arrayCampos.push([{"xtype":'displayfield',"name":"demandadoProcedimiento","fieldLabel":"Demandado" ,"value":"",allowBlank:true, "hiddenName":"demandadoProcedimiento", id:'demandadoProcedimiento_id' + this.idFactoria}
       							,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
    	                        ,{"xtype":'datefield',"name":"d_fecResolucionAnotEmb","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolAnotEmb","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":["Solicitud","Anotado","Denegada"],"editable":"false",mode:'local', "name":"d_tipoAnotEmb","hiddenName":"d_tipoAnotEmb","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		,id:'d_tipoAnotEmb_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoAnotEmb_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionAnotEmb'+idFactoria);
									if(combo.getValue()=='Denegada'){
										plazoImpugnacion.setVisible(true);
										}
									else{
										plazoImpugnacion.setVisible(false);
										}
						      		}
						      	, render:function(){
					      			var textoInformativo = this.findParentByType(Ext.form.FormPanel).getForm().findField('textoInformativo');
									textoInformativo.setValue("Por favor, actualice la informaci&oacute;n del embargo a trav&eacute;s de la pesta&ntilde;a de bienes del tr&aacute;mite de embargo.");
									textoInformativo.setVisible(true);
					      			}
						      	}}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionAnotEmb'+this.idFactoria}
      	]);
    	//id: 26 ETJ:Embargo: Renovación anotación
    	this.arrayCampos.push([{"xtype":'displayfield',"name":"demandadoProcedimiento","fieldLabel":"Demandado" ,"value":"",allowBlank:true, "hiddenName":"demandadoProcedimiento", id:'demandadoProcedimiento_id' + this.idFactoria}
       						,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
    	                    ,{"xtype":'datefield',"name":"d_fecResolucionRenovAnotEmb","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolRenovAnotEmb","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Anotado","Denegada"],"editable":"false",mode:'local', "name":"d_tipoRenovAnotEmb","hiddenName":"d_tipoRenovAnotEmb","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		,id:'d_tipoRenovAnotEmb_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoRenovAnotEmb_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionRenovAnotEmb'+idFactoria);
								if(combo.getValue()=='Denegada'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      		, render:function(){
				      			var textoInformativo = this.findParentByType(Ext.form.FormPanel).getForm().findField('textoInformativo');
								textoInformativo.setValue("Por favor, actualice la informaci&oacute;n del embargo a trav&eacute;s de la pesta&ntilde;a de bienes del tr&aacute;mite de embargo.");
								textoInformativo.setVisible(true);
				      			}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionRenovAnotEmb'+this.idFactoria}
      	]);
    	
    	// id: 27 ETJ:Requerimiento de retención al pagador: Solicitud
    	this.arrayCampos.push([{"xtype":'displayfield',"name":"demandadoProcedimiento","fieldLabel":"Demandado" ,"value":"",allowBlank:true, "hiddenName":"demandadoProcedimiento", id:'demandadoProcedimiento_id' + this.idFactoria}
							,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
    	                    ,{"xtype":'datefield',"name":"d_fecResolucionReqRetPag","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolReqRetPag","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Aprobada","Denegada"],"editable":"false",mode:'local', "name":"d_tipoReqRetPag","hiddenName":"d_tipoReqRetPag","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id:'d_tipoReqRetPag_id'+this.idFactoria
					      		, listeners:{select:function(combo){
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionReqRetPag'+idFactoria);
								var importeRetencion=Ext.getCmp('d_importeRetencion'+idFactoria);
								var importeBaseRetencion=Ext.getCmp('d_importeBaseRetencion'+idFactoria);
								if(combo.getValue()=='Denegada'){
									plazoImpugnacion.setVisible(true);
									importeRetencion.setVisible(false);
									importeBaseRetencion.setVisible(false);
									}
								else{
									plazoImpugnacion.setVisible(false);
									importeRetencion.setVisible(true);
									importeBaseRetencion.setVisible(true);
									}
					      		}
					      		, render:function(){
				      			var textoInformativo = this.findParentByType(Ext.form.FormPanel).getForm().findField('textoInformativo');
								textoInformativo.setValue("Por favor, actualice la informaci&oacute;n del embargo a trav&eacute;s de la pesta&ntilde;a de bienes del tr&aacute;mite de embargo");
								textoInformativo.setVisible(true);
					      		}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionReqRetPag'+this.idFactoria}
					      	,{"xtype":'textfield',"name":"d_nombrePagador","fieldLabel":"Pagador",allowBlank:true}
					      	,{"xtype":'numberfield',"name":"d_importeBaseRetencion","fieldLabel":"Importe base de retenci&oacute;n",allowBlank:true, id:'d_importeBaseRetencion'+this.idFactoria}
					      	,{"xtype":'textfield',"name":"d_cifPagador","fieldLabel":"CIF",allowBlank:true, hidden:false,disabled:false}
					      	,{"xtype":'numberfield',"name":"d_importeRetencion","fieldLabel":"Importe de retenci&oacute;n",allowBlank:true, id:'d_importeRetencion'+this.idFactoria}
					    	,{"xtype":'textfield',"name":"d_direccionPagador","fieldLabel":"Direcci&oacute;n pagador",allowBlank:true, hidden:false,disabled:false}
    	]);
    	// id: 28 ETJ:Requerimiento de retención al pagador: Confirmación del pagador
    	this.arrayCampos.push([{"xtype":'displayfield',"name":"demandadoProcedimiento","fieldLabel":"Demandado" ,"value":"",allowBlank:true, "hiddenName":"demandadoProcedimiento", id:'demandadoProcedimiento_id' + this.idFactoria}
							,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
    	                    ,{"xtype":'datefield',"name":"d_fecResolucionReqRetPagConf","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolReqRetPagConf","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Positivo","Negativo"],"editable":"false",mode:'local', "name":"d_tipoReqRetPagConf","hiddenName":"d_tipoReqRetPagConf","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoReqRetPagConf'+this.idFactoria
					      		, listeners:{select:function(combo){
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionReqRetPagConf'+idFactoria);
								var importeRetencion=Ext.getCmp('d_importeRetencionConf'+idFactoria);
								var importeBaseRetencion=Ext.getCmp('d_importeBaseRetencionConf'+idFactoria);
								if(combo.getValue()=='Negativo'){
									plazoImpugnacion.setVisible(true);
									importeRetencion.setVisible(false);
									importeBaseRetencion.setVisible(false);
									}
								else{
									plazoImpugnacion.setVisible(false);
									importeRetencion.setVisible(true);
									importeBaseRetencion.setVisible(true);
									}
					      		}
					      	}}
					      
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionReqRetPagConf'+this.idFactoria}
					      	,{"xtype":'textfield',"name":"d_nombrePagador","fieldLabel":"Pagador",allowBlank:true}
					      	,{"xtype":'numberfield',"name":"d_importeBaseRetencion","fieldLabel":"Importe base de retenci&oacute;n",allowBlank:true, id:'d_importeBaseRetencionConf'+this.idFactoria}
					      	,{"xtype":'textfield',"name":"d_cifPagador","fieldLabel":"CIF",allowBlank:true, hidden:false,disabled:false}
					      	,{"xtype":'numberfield',"name":"d_importeRetencion","fieldLabel":"Importe de retenci&oacute;n",allowBlank:true, id:'d_importeRetencionConf'+this.idFactoria}
					      	,{"xtype":'textfield',"name":"d_direccionPagador","fieldLabel":"Direcci&oacute;n pagador",allowBlank:true, hidden:false,disabled:false}
					      	]);
    	
    	// id: 29 ETJ:Certificación dominio y cargas
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionCertDomCar","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolCertDomCar","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":["Solicitud","Certificacion"],"editable":"false",mode:'local', "name":"d_tipoCertDomCar","hiddenName":"d_tipoCertDomCar","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		}
						      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
						        	,displayField:'codigo',valueField:'id', "autoload":true
									, listeners:{select :function(combo){
    						      		var idFactoria = combo.id.replace('d_nombreDemandado_id','');
    									var comboBienes=Ext.getCmp('d_bienesDemandado_id' + idFactoria);
						      			if (comboBienes!=''){
											var storeBienes= comboBienes.getStore();
											storeBienes.load({params:{idDemandado:combo.getValue()}});
						      			}
									}
									}}
						      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:true ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
      	]);
    	// id: 30 ETJ:Calificación negativa del Registro
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionCalNegReg","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolCalNegReg","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
						        	,displayField:'codigo',valueField:'id', "autoload":true
									, listeners:{select :function(combo){
    						      		var idFactoria = combo.id.replace('d_nombreDemandado_id','');
    									var comboBienes=Ext.getCmp('d_bienesDemandado_id' + idFactoria);
						      			if (comboBienes!=''){
											var storeBienes= comboBienes.getStore();
											storeBienes.load({params:{idDemandado:combo.getValue()}});
						      			}
									}
									}}
						      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:true ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
      	]);
    	//id: 31 HIP:Certificación cargas precedentes
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionCertCargPrec","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolCertCargPrec","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Certificacion"],"editable":"false",mode:'local', "name":"d_tipoCertCargPrec","hiddenName":"d_tipoCertCargPrec","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
						      		var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var comboBienes=Ext.getCmp('d_bienesDemandado_id' + idFactoria);
					      			if (comboBienes!=''){
										var storeBienes= comboBienes.getStore();
										storeBienes.load({params:{idDemandado:combo.getValue()}});
					      			}
								}
								}}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:true ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
      	]);
    	//id: 32 HIP:Solicitud de ampliación de certificación cargas precedentes incompleta
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionCertCargPrecInc","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolCertCargPrecInc","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado", "hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
						        	,displayField:'codigo',valueField:'id', "autoload":true
									, listeners:{select :function(combo){
    						      		var idFactoria = combo.id.replace('d_nombreDemandado_id','');
    									var comboBienes=Ext.getCmp('d_bienesDemandado_id' + idFactoria);
						      			if (comboBienes!=''){
											var storeBienes= comboBienes.getStore();
											storeBienes.load({params:{idDemandado:combo.getValue()}});
						      			}
									}
									}}
						      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:true ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
      	]);
    	//id: 33 ETJ:Oposición: Sentencia
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionOpoSent","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolOpoSent","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":["Favorable","Desfavorable"],"editable":"false",mode:'local', "name":"d_tipoOpoSent","hiddenName":"d_tipoOpoSent","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		,id:'d_tipoOpoSent'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoOpoSent_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionOpoSent'+idFactoria);
									if(combo.getValue()=='Desfavorable'){
										plazoImpugnacion.setVisible(true);
										}
									else{
										plazoImpugnacion.setVisible(false);
										}
						      		}
						      	}}
						      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
						        	,displayField:'codigo',valueField:'id', "autoload":true
									, listeners:{select :function(combo){
    						      		var idFactoria = combo.id.replace('d_nombreDemandado_id','');
    									var comboBienes=Ext.getCmp('d_bienesDemandado_id' + idFactoria);
						      			if (comboBienes!=''){
											var storeBienes= comboBienes.getStore();
											storeBienes.load({params:{idDemandado:combo.getValue()}});
						      			}
									}
									}}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionOpoSent'+this.idFactoria}
						      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:true ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
      	]);
    	//id: 34 ETJ:Oposición: Recurso Sentencia
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionOpoRec","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolOpoRec","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":["Por Contrario","Por Lindorff"],"editable":"false",mode:'local', "name":"d_tipoOpoRec","hiddenName":"d_tipoOpoRec","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		,id:'d_tipoOpoRec_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoOpoRec_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionOpoRec'+idFactoria);
									if(combo.getValue()=='Por Contrario'){
										plazoImpugnacion.setVisible(true);
										}
									else{
										plazoImpugnacion.setVisible(false);
										}
						      		}
						      	}}
						      	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
    	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
    							}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionOpoRec'+this.idFactoria}
      	]);
    	//id: 35 ETJ:Audiencia Previa
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAudPrev","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolAudPrev","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":[["SENY","Señalamiento"],["SUSP","Suspension"]],"editable":"false",mode:'local', "name":"d_tipoAudPrev","hiddenName":"d_tipoAudPrev","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		,id:'d_tipoAudPrev_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoAudPrev_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionAudPrev'+idFactoria);
									var nuevaFechaSenyalamiento=Ext.getCmp('d_fecSenyNuevAudPrev'+idFactoria);
									var fechaSenySuspendida=Ext.getCmp('d_fecSenySuspAudPrev'+idFactoria);
									var fechaSenyAudPrev=Ext.getCmp('d_fecSenyAudPrev'+idFactoria);
									if(combo.getValue()=='SUSP'){
										plazoImpugnacion.setVisible(true);
										nuevaFechaSenyalamiento.setVisible(true);
										fechaSenySuspendida.setVisible(true);
										fechaSenyAudPrev.setVisible(false);
										}
									else{
										plazoImpugnacion.setVisible(false);
										nuevaFechaSenyalamiento.setVisible(false);
										fechaSenySuspendida.setVisible(false);
										fechaSenyAudPrev.setVisible(true);
										}
						      		}
						      	}}
						      	,{"xtype":'datefield',"name":"d_fecSenyAudPrev","fieldLabel":"Fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyAudPrev', minValue: fechaMinima}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionAudPrev'}
						      	,{"xtype":'datefield',"name":"d_fecSenySuspAudPrev","fieldLabel":"Fecha se&ntilde;alamiento suspendida",allowBlank:true, id:'d_fecSenySuspAudPrev', hidden:true, minValue: fechaMinima}
						      	,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
						      	,{"xtype":'datefield',"name":"d_fecSenyNuevAudPrev","fieldLabel":"Nueva fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyNuevAudPrev', hidden:true, minValue: fechaMinima}	      	
      	]);
    	//id: 36 ETJ:Vista
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionVista","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolVista","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":[["SENY","Señalamiento"],["SUSP","Suspension"]],"editable":"false",mode:'local', "name":"d_tipoVista","hiddenName":"d_tipoVista","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoVista_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoVista_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionVista'+idFactoria);
								var nuevaFechaSenyalamiento=Ext.getCmp('d_fecSenyNuevVista'+idFactoria);
								var fechaSenySuspendida=Ext.getCmp('d_fecSenySuspVista'+idFactoria);
								var fechaSenyAudPrev=Ext.getCmp('d_fecSenyVista'+idFactoria);
								if(combo.getValue()=='SUSP'){
									plazoImpugnacion.setVisible(true);
									nuevaFechaSenyalamiento.setVisible(true);
									fechaSenySuspendida.setVisible(true);
									fechaSenyAudPrev.setVisible(false);
									}
								else{
									plazoImpugnacion.setVisible(false);
									nuevaFechaSenyalamiento.setVisible(false);
									fechaSenySuspendida.setVisible(false);
									fechaSenyAudPrev.setVisible(true);
									}
					      		}
					      	}}
					      	,{"xtype":'datefield',"name":"d_fecSenyVista","fieldLabel":"Fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyVista'+this.idFactoria, minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionVista'+this.idFactoria}
					      	,{"xtype":'datefield',"name":"d_fecSenySuspVista","fieldLabel":"Fecha se&ntilde;alamiento suspendida",allowBlank:true, id:'d_fecSenySuspVista'+this.idFactoria, hidden:true, minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
					      	,{"xtype":'datefield',"name":"d_fecSenyNuevVista","fieldLabel":"Nueva fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyNuevVista'+this.idFactoria, hidden:true, minValue: fechaMinima}	      	
		]);
    	//id: 37 ETJ:Diligencia Final
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDilFin","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolDilFin","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Traslado"],"editable":"false",mode:'local', "name":"d_tipoDilFin","hiddenName":"d_tipoDilFin","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id:'d_tipoDilFin_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoDilFin_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionDilFin'+idFactoria);
								if(combo.getValue()=='Solicitud'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionDilFin'+this.idFactoria}
		]);
    	//id: 38 ETJ:Sentencia
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionSent","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolSent","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Estimatoria","Desestimatoria"],"editable":"false",mode:'local', "name":"d_tipoSent","hiddenName":"d_tipoSent","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoSent_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoSent_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionSent'+idFactoria);
								if(combo.getValue()=='Desestimatoria'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionSent'+this.idFactoria}
		]);
    	//id: 39 ETJ:Sentencia: Impugnación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionSentImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolSentImp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Por Lindorff","Por contrario"],"editable":"false",mode:'local', "name":"d_tipoSentImp","hiddenName":"d_tipoSentImp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoSentImp_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoSentImp_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionSentImp'+idFactoria);
								if(combo.getValue()=='Por contrario'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionSentImp'+this.idFactoria}
		]);
    	//id: 40: ETJ:Adjudicacion
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAdj","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAdj","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","A Lindorff", "A contrario"],"editable":"false",mode:'local', "name":"d_tipoAdj","hiddenName":"d_tipoAdj","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					        ,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}			      	
		]);
    	//id: 41: ETJ:Adjudicación: Subsanación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAdjSub","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAdjSub","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					        ,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}			      	
		]);
    	//id: 42 :ETJ:Adjudicación: Testimonio del Decreto
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAdjTestDec","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAdjTestDec","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Entrega"],"editable":"false",mode:'local', "name":"d_tipoAdjTestDec","hiddenName":"d_tipoAdjTestDec","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					        ,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado", "hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}			      	
		]);
    	//id: 43 :ETJ:Tasación de costas
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionTasCos","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolTasCos","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Positivo","Negativo"],"editable":"false",mode:'local', "name":"d_tipoTasCos","hiddenName":"d_tipoTasCos","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id:'d_tipoTasCos_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoTasCos_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionTasCos'+idFactoria);
								var totalParcial=Ext.getCmp('d_tasacionCostasTotal_id'+idFactoria);
								if(combo.getValue()=='Negativo'){
									plazoImpugnacion.setVisible(true);
									totalParcial.setVisible(false);
									}
								else if (combo.getValue()=='Positivo'){
									plazoImpugnacion.setVisible(false);
									totalParcial.setVisible(true);
									}
								else {
									plazoImpugnacion.setVisible(false);
									totalParcial.setVisible(false);
								}
					      		}
					      	}}
					      	,{"xtype":'combo',"store":["Total","Parcial"],"editable":"false",mode:'local', "name":"d_tasacionCostasTotal", "hiddenName":"d_tasacionCostasTotal","fieldLabel":"Total / Parcial", id:'d_tasacionCostasTotal_id'+this.idFactoria,triggerAction: 'all',allowBlank:true}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionTasCos'+this.idFactoria}
		]);
    	//id: 44 :ETJ:Tasación de costas: Impugnación Notificación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionTasCosImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolTasCosImp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Por contrario","Por Lindorff"],"editable":"false",mode:'local', "name":"d_tipoTasCosImp","hiddenName":"d_tipoTasCosImp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoTasCosImp_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoTasCosImp_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionTasCosImp'+idFactoria);
								if(combo.getValue()=='Por contrario'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionTasCosImp'+idFactoria}		      	
		]);
    	//id: 45 :ETJ:Tasación costas: Vista
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionTasCosVist","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolTasCosVist","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":[["SENY","Señalamiento"],["SUSP","Suspension"]],"editable":"false",mode:'local', "name":"d_tipoTasCosVist","hiddenName":"d_tipoTasCosVist","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoTasCosVist_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoTasCosVist_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionTasCosVist'+idFactoria);
								var nuevaFechaSenyalamiento=Ext.getCmp('d_fecSenyNuevTasCosVist'+idFactoria);
								var fechaSenySuspendida=Ext.getCmp('d_fecSenySuspTasCosVist'+idFactoria);
								var fechaSenyTasCosVist=Ext.getCmp('d_fecSenyTasCosVist'+idFactoria);
								if(combo.getValue()=='SUSP'){
									plazoImpugnacion.setVisible(true);
									nuevaFechaSenyalamiento.setVisible(true);
									fechaSenySuspendida.setVisible(true);
									fechaSenyTasCosVist.setVisible(false);
									}
								else{
									plazoImpugnacion.setVisible(false);
									nuevaFechaSenyalamiento.setVisible(false);
									fechaSenySuspendida.setVisible(false);
									fechaSenyTasCosVist.setVisible(true);
									}
					      		}
					      	}}
					      	,{"xtype":'datefield',"name":"d_fecSenyTasCosVist","fieldLabel":"Fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyTasCosVist'+this.idFactoria, minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionTasCosVist'+this.idfactoria}
					      	,{"xtype":'datefield',"name":"d_fecSenySuspTasCosVist","fieldLabel":"Fecha se&ntilde;alamiento suspendida",allowBlank:true, id:'d_fecSenySuspTasCosVist'+this.idFactoria, hidden:true, minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
					      	,{"xtype":'datefield',"name":"d_fecSenyNuevTasCosVist","fieldLabel":"Nueva fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyNuevTasCosVist'+this.idFactoria, hidden:true, minValue: fechaMinima}	      	
		]);
    	//id: 46 :ETJ:Tasación costas: Resolucion
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionTasCosRes","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolTasCosRes","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":[["Estimatoria","Aprobada"],["Desestimatoria","Denegada"]],"editable":"false",mode:'local', "name":"d_tipoTasCosRes","hiddenName":"d_tipoTasCosRes","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id:'d_tipoTasCosRes_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoTasCosRes_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionTasCosRes'+idFactoria);
								if(combo.getValue()=='Suspension'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionTasCosRes'+this.idFactoria}      	
		]);
    	//id: 47 : Tasación costas: Impugnación Resolución Vista
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionTasCosResVis","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolTasCosResVis","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Por Lindorff","Por contrario"],"editable":"false",mode:'local', "name":"d_tipoTasCosResVis","hiddenName":"d_tipoTasCosResVis","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true}  	
		]);
    	//id: 48 : Tasación costas: Auto aprobación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionTasCosAutAp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolTasCosAutAp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					    	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true}      	
		]);
    	//id: 49 :ETJ:Liquidación intereses
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLiqInt","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolLiqInt","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Favorable", "Desfavorable"],"editable":"false",mode:'local', "name":"d_tipoLiqInt","hiddenName":"d_tipoLiqInt","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoLiqInt_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoLiqInt_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionLiqInt'+idFactoria);
								var liquidacionIntereses=Ext.getCmp('d_liquidacionInteresesTotal_id'+idFactoria);
								if(combo.getValue()=='Desfavorable'){
									plazoImpugnacion.setVisible(true);
									liquidacionIntereses.setVisible(false);
									}
								else if (combo.getValue()=='Favorable'){
									plazoImpugnacion.setVisible(false);
									liquidacionIntereses.setVisible(true);
									}
								else {
									plazoImpugnacion.setVisible(false);
									liquidacionIntereses.setVisible(false);
								}
					      		}
					      	}}
					      	,{"xtype":'combo',"store":["Total","Parcial"],"editable":"false",mode:'local', "name":"d_liquidacionInteresesTotal", "hiddenName":"d_liquidacionInteresesTotal","fieldLabel":"Total / Parcial",id:'d_liquidacionInteresesTotal_id'+this.idFactoria,triggerAction: 'all',allowBlank:true}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionLiqInt'+this.idFactoria}      	
		]);
    	//id:50 :ETJ:Liquidación intereses: Impugnación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLiqIntImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolLiqIntImp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":["Por Lindorff", "Por Contrario"],"editable":"false",mode:'local', "name":"d_tipoLiqIntImp","hiddenName":"d_tipoLiqIntImp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		, id: 'd_tipoLiqIntImp_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoLiqIntImp_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionLiqIntImp'+idFactoria);
									if(combo.getValue()=='Por Contrario'){
										plazoImpugnacion.setVisible(true);
										}
									else{
										plazoImpugnacion.setVisible(false);
										}
						      		}
						      	}}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionLiqIntImp'+this.idFactoria}      	
		]);
    	// id: 51 : ETJ :Liquidación intereses: Vista
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLiqIntVist","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolLiqIntVist","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":[["SENY","Señalamiento"],["SUSP","Suspension"]],"editable":"false",mode:'local', "name":"d_tipoLiqIntVist","hiddenName":"d_tipoLiqIntVist","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		,id: 'd_tipoLiqIntVist_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoLiqIntVist_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionLiqIntVist'+idFactoria);
								var nuevaFechaSenyalamiento=Ext.getCmp('d_fecSenyNuevLiqIntVist'+idFactoria);
								var fechaSenySuspendida=Ext.getCmp('d_fecSenySuspLiqIntVist'+idFactoria);
								var fechaSenyLiqIntVist=Ext.getCmp('d_fecSenyLiqIntVist'+idFactoria);
								if(combo.getValue()=='SUSP'){
									plazoImpugnacion.setVisible(true);
									nuevaFechaSenyalamiento.setVisible(true);
									fechaSenySuspendida.setVisible(true);
									fechaSenyLiqIntVist.setVisible(false);
									}
								else{
									plazoImpugnacion.setVisible(false);
									nuevaFechaSenyalamiento.setVisible(false);
									fechaSenySuspendida.setVisible(false);
									fechaSenyLiqIntVist.setVisible(true);
									}
					      		}
					      	}}
					      	,{"xtype":'datefield',"name":"d_fecSenyLiqIntVist","fieldLabel":"Fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyLiqIntVist'+this.idFactoria, minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionLiqIntVist'+this.idFactoria}
					      	,{"xtype":'datefield',"name":"d_fecSenySuspLiqIntVist","fieldLabel":"Fecha se&ntilde;alamiento suspendida",allowBlank:true, id:'d_fecSenySuspLiqIntVist'+this.idFactoria, hidden:true, minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
					      	,{"xtype":'datefield',"name":"d_fecSenyNuevLiqIntVist","fieldLabel":"Nueva fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyNuevLiqIntVist'+this.idFactoria, hidden:true, minValue: fechaMinima}	      	
		]);
    	// id : 52 : ETJ :Liquidación intereses: Resolución Vista
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLiqIntResVis","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolLiqIntResVis","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Favorable", "Desfavorable"],"editable":"false",mode:'local', "name":"d_tipoLiqIntResVis","hiddenName":"d_tipoLiqIntResVis","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoLiqResVis_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoLiqIntResVis_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionLiqIntResVis'+idFactoria);
								if(combo.getValue()=='Desfavorable'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionLiqIntResVis'+this.idFactoria}      	
		]);
    	// id : 53 : ETJ :Liquidación intereses: Impugnación Resolución Vista
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLiqIntResImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolLiqIntResImp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Por Lindorff", "Por Contrario"],"editable":"false",mode:'local', "name":"d_tipoLiqIntResImp","hiddenName":"d_tipoLiqIntResImp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		,id:'d_tipoLiqIntResImp_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoLiqIntResImp_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionLiqResIntImp'+idFactoria);
								if(combo.getValue()=='Por Contrario'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionLiqResIntImp'+this.idFactoria}      	
		]);
    	// id : 54 : ETJ :SUBASTA
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionSub","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolSub","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":[["SOL","Solicitud"],["DEN","Denegada"],["SENY","Señalamiento"],["SUSP","Suspension"]],"editable":"false",mode:'local'
					      		, "name":"d_tipoSub","hiddenName":"d_tipoSub","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false, id: 'd_tipoSub_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoSub_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionSub'+idFactoria);
								var valorTasacion=Ext.getCmp('d_valorTasacion'+idFactoria);
								var fechaSenyalamiento=Ext.getCmp('d_fecSenySub'+idFactoria);
								var fechaSenyalamientoSusp=Ext.getCmp('d_fecSenySuspSub'+idFactoria);
								var nuevaFechaSenyalamiento=Ext.getCmp('d_fecSenyNuevSub'+idFactoria);
								if(combo.getValue()=='SOL'){
									valorTasacion.setVisible(true);
									fechaSenyalamiento.setVisible(false);
									plazoImpugnacion.setVisible(false);
									fechaSenyalamientoSusp.setVisible(false);
									nuevaFechaSenyalamiento.setVisible(false);
									}
								else{
									valorTasacion.setVisible(false);
									if (combo.getValue()=='SENY'){
										fechaSenyalamiento.setVisible(true);
										fechaSenyalamientoSusp.setVisible(false);
										nuevaFechaSenyalamiento.setVisible(false);
										plazoImpugnacion.setVisible(false);
									}else {
										if(combo.getValue()=='SUSP'){
											plazoImpugnacion.setVisible(true);
											fechaSenyalamiento.setVisible(false);
											fechaSenyalamientoSusp.setVisible(true);
											nuevaFechaSenyalamiento.setVisible(true);
										} else {
											plazoImpugnacion.setVisible(true);
											fechaSenyalamiento.setVisible(false);
											fechaSenyalamientoSusp.setVisible(false);
											nuevaFechaSenyalamiento.setVisible(false);
										}	
									} 
					      		}
					      	}}}
					      	,{"xtype":'datefield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,hidden:true, minValue: fechaMinima}
					      	,{"xtype":'datefield',"name":"d_fecSenySub","fieldLabel":"Fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenySub'+this.idFactoria, hidden:true, minValue: fechaMinima}
					      	,{"xtype":'datefield',"name":"hidden2","fieldLabel":"oculto",allowBlank:true,hidden:true, minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionSub'+this.idFactoria}
					      	,{"xtype":'datefield',"name":"d_fecSenySuspSub","fieldLabel":"Fecha se&ntilde;alamiento suspendida",allowBlank:true, id:'d_fecSenySuspSub'+this.idFactoria, hidden:true, minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"d_valorTasacion","fieldLabel":"Valor de tasaci&oacute;n",allowBlank:true, hidden:true, id:'d_valorTasacion'+this.idFactoria}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					        ,{"xtype":'datefield',"name":"d_fecSenyNuevSub","fieldLabel":"Nueva fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyNuevSub', hidden:true, minValue: fechaMinima}	
					        ,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}			      	
					      
		]);
    	//id: 55 :ETJ:Subasta: Acta
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionSubAct","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolSubAct","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["A Lindorff", "A tercero"],"editable":"false",mode:'local', "name":"d_tipoSubAct","hiddenName":"d_tipoSubAct","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false
					      		,id:'d_tipoSubAct_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoSubAct_id','');
								var cesionRemate=Ext.getCmp('d_cesionRemate'+idFactoria);
								if(combo.getValue()=='A Lindorff'){
									cesionRemate.setVisible(true);
									}
								else{
									cesionRemate.setVisible(false);	
					      		}
					      	}}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					    	,{"xtype":'numberfield',"name":"d_valorAdjudicacion","fieldLabel":"Valor de adjudicac&oacute;n",allowBlank:true}			      	
					        ,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado", "hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
					        ,{"xtype":'combo',"store": ["Si", "No"], "name":"d_cesionRemate","fieldLabel":"Con Cesi&oacute;n Remate","autoload":true, mode:'local',triggerAction: 'all',resizable:true, hidden:true, id:'d_cesionRemate'+this.idFactoria}
		]);
    	//id: 56 :ETJ: Mandamiento de pago
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionManPag","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolManPag","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Notificacion"],"editable":"false",mode:'local', "name":"d_tipoManPag","hiddenName":"d_tipoManPag","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true}  	
		]);	
    	//id: 57 :ETJ: Avaluo
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAvaluo","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAvaluo","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Notificacion"],"editable":"false",mode:'local', "name":"d_tipoAvaluo","hiddenName":"d_tipoAvaluo","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id:'d_tipoAvaluo_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoLiqInt_id','');					      		
								var valor=Ext.getCmp('d_valor'+idFactoria);
								if(combo.getValue()=='Notificacion'){
									valor.setVisible(true);
									}
								else{
									valor.setVisible(false);	
					      		}
					      	}}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'numberfield',"name":"d_valorAvaluo","fieldLabel":"Valor",allowBlank:true, id:'d_valor'+this.idFactoria, hidden:true}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
		]);	
    	//id: 58 :ETJ: Avaluo: Tasador Judicial
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAvaluotj","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAvaluotj","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Nombramiento","Aceptacion"],"editable":"false",mode:'local', "name":"d_tipoAvaluotj","hiddenName":"d_tipoAvaluotj","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id:'d_tipoAvaluotj_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoAvaluotj_id','');
								var valor=Ext.getCmp('d_valorAvaluotj'+idFactoria);
								var plazo=Ext.getCmp('d_plazoConsig'+idFactoria);
								if(combo.getValue()=='Aceptacion'){
									valor.setVisible(true);
									plazo.setVisible(true);
									}
								else{
									valor.setVisible(false);
									plazo.setVisible(false);
					      		}
					      	}}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'numberfield',"name":"d_valorAvaluotj","fieldLabel":"Provisi&oacute;n de fondos",allowBlank:true, id:'d_valorAvaluotj'+this.idFactoria, hidden:true}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
					    	,{"xtype":'numberfield',"name":"d_plazoConsig","fieldLabel":"Plazo consignaci&oacute;n prov. Fondos",allowBlank:true, id:'d_plazoConsig'+this.idFactoria, hidden:true}
		]);
    	//id: 59 : ETJ:Avalúo: Alegaciones
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAvaluoAleg","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAvaluoAleg","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true					      		
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
		]);
    	// id: 60: ETJ:Avalúo: Comparecencia
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAvaluoComp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolAvaluoComp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":[["SENY","Señalamiento"],["SUSP","Suspension"]],"editable":"false",mode:'local', "name":"d_tipoAvaluoComp","hiddenName":"d_tipoAvaluoComp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		,id:'d_tipoAvaluoComp_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoAvaluoComp_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionAvaluoComp'+idFactoria);
									var nuevaFechaSenyalamiento=Ext.getCmp('d_fecSenyNuevAvaluoComp'+idFactoria);
									var fechaSenySuspendida=Ext.getCmp('d_fecSenySuspAvaluoComp'+idFactoria);
									var fechaSenyAudPrev=Ext.getCmp('d_fecSenyAvaluoComp'+idFactoria);
									if(combo.getValue()=='SUSP'){
										plazoImpugnacion.setVisible(true);
										nuevaFechaSenyalamiento.setVisible(true);
										fechaSenySuspendida.setVisible(true);
										fechaSenyAudPrev.setVisible(false);
										}
									else{
										plazoImpugnacion.setVisible(false);
										nuevaFechaSenyalamiento.setVisible(false);
										fechaSenySuspendida.setVisible(false);
										fechaSenyAudPrev.setVisible(true);
										}
						      		}
						      	}}
						      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
						        	,displayField:'codigo',valueField:'id', "autoload":true
									, listeners:{select :function(combo){
										var idFactoria = combo.id.replace('d_nombreDemandado_id','');
										var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
										storeBienes.load({params:{idDemandado:combo.getValue()}});
									}
									}}
						      	,{"xtype":'numberfield',"name":"hidden3","fieldLabel":"oculto",allowBlank:true,  hidden:true}
						      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
						      	,{"xtype":'datefield',"name":"d_fecSenyAvaluoComp","fieldLabel":"Fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyAvaluoComp'+this.idFactoria, minValue: fechaMinima}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionAvaluoComp'+this.idFactoria}
						      	,{"xtype":'datefield',"name":"d_fecSenySuspAvaluoComp","fieldLabel":"Fecha se&ntilde;alamiento suspendida",allowBlank:true, id:'d_fecSenySuspAvaluoComp'+this.idFactoria, hidden:true, minValue: fechaMinima}
						      	,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
						      	,{"xtype":'datefield',"name":"d_fecSenyNuevAvaluoComp","fieldLabel":"Nueva fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyNuevAvaluoComp'+this.idFactoria, hidden:true, minValue: fechaMinima}	      	
		]);
    	//id: 61 :ETJ: Avalúo: Resolución
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAvRes","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAvRes","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Favorable", "Desfavorable"],"editable":"false",mode:'local', "name":"d_tipoAvRes","hiddenName":"d_tipoAvRes","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoAvRes_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoAvRes_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionAvRes'+idFactoria);
								if(combo.getValue()=='Desfavorable'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionAvRes'+this.idFactoria}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado", "hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}      	
		]);
    	//id: 62 :ETJ: Avalúo: Impugnación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAvImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAvImp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Por Lindorff", "Por contrario"],"editable":"false",mode:'local', "name":"d_tipoAvImp","hiddenName":"d_tipoAvImp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoAvImp_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoAvImp_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionAvImp'+idFactoria);
								if(combo.getValue()=='Por contrario'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionAvImp'+this.idFactoria}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}      	
		]);
    	//id: 63 :ETJ: Avalúo: Justiprecio
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionAvaluoJust","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolAvaluoJust","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Notificacion"],"editable":"false",mode:'local', "name":"d_tipoAvaluoJust","hiddenName":"d_tipoAvaluoJust","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoAvaluoJust_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoAvaluoJust_id','');
								var valor=Ext.getCmp('d_valorJust'+idFactoria);
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionAvJust'+idFactoria);
								if(combo.getValue()=='Notificacion'){
									valor.setVisible(true);
									plazoImpugnacion.setVisible(true);
									}
								else{
									valor.setVisible(false);
									plazoImpugnacion.setVisible(false);
					      		}
					      	}}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'numberfield',"name":"d_valorAvaluoJust","fieldLabel":"Valor",allowBlank:true, id:'d_valorJust'+this.idFactoria, hidden:true}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
					    	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionAvJust'+this.idFactoria}
		]);
    	// id: 64: ETJ:Cesión remate: Comparecencia
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionCesRemComp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolCesRemComp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":[["SENY","Señalamiento"],["SUSP","Suspension"]],"editable":"false",mode:'local', "name":"d_tipoCesRemComp","hiddenName":"d_tipoCesRemComp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		, id: 'd_tipoCesRemComp_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoCesRemComp_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionCesRemComp'+idFactoria);
									var nuevaFechaSenyalamiento=Ext.getCmp('d_fecSenyNuevCesRemComp'+idFactoria);
									var fechaSenySuspendida=Ext.getCmp('d_fecSenySuspCesRemComp'+idFactoria);
									var fechaSenyAudPrev=Ext.getCmp('d_fecSenyCesRemComp'+idFactoria);
									if(combo.getValue()=='SUSP'){
										plazoImpugnacion.setVisible(true);
										nuevaFechaSenyalamiento.setVisible(true);
										fechaSenySuspendida.setVisible(true);
										fechaSenyAudPrev.setVisible(false);
										}
									else{
										plazoImpugnacion.setVisible(false);
										nuevaFechaSenyalamiento.setVisible(false);
										fechaSenySuspendida.setVisible(false);
										fechaSenyAudPrev.setVisible(true);
										}
						      		}
						      	}}
						      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
						        	,displayField:'codigo',valueField:'id', "autoload":true
									, listeners:{select :function(combo){
										var idFactoria = combo.id.replace('d_nombreDemandado_id','');
										var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
										storeBienes.load({params:{idDemandado:combo.getValue()}});
									}
									}}
						      	,{"xtype":'numberfield',"name":"hidden3","fieldLabel":"oculto",allowBlank:true,  hidden:true}
						      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
						      	,{"xtype":'datefield',"name":"d_fecSenyCesRemComp","fieldLabel":"Fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyCesRemComp'+this.idFactoria, minValue: fechaMinima}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionCesRemComp'+this.idFactoria}
						      	,{"xtype":'datefield',"name":"d_fecSenySuspCesRemComp","fieldLabel":"Fecha se&ntilde;alamiento suspendida",allowBlank:true, id:'d_fecSenySuspCesRemComp'+this.idFactoria, hidden:true, minValue: fechaMinima}
						      	,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
						      	,{"xtype":'datefield',"name":"d_fecSenyNuevCesRemComp","fieldLabel":"Nueva fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyNuevCesRemComp'+this.idFactoria, hidden:true, minValue: fechaMinima}	      	
		]);
    	//id: 65 : ETJ:(Confirmación de presentación) Solicitud posesión bien
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionSolPosBien","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolSolPosBien","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
		]);
    	//id: 66 :ETJ: Lanzamiento
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLanz","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolLanz","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Notificacion"],"editable":"false",mode:'local', "name":"d_tipoLanz","hiddenName":"d_tipoLanz","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					    	,{"xtype":'numberfield',"name":"hidden3","fieldLabel":"oculto",allowBlank:true,  hidden:true}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
		]);
    	// id: 67: ETJ:Lanzamiento: Vista
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLanzVist","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
						      	,{"xtype":'datefield',"name":"d_fecRecepResolLanzVist","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
						      	,{"xtype":'combo',"store":[["SENY","Señalamiento"],["SUSP","Suspension"]],"editable":"false",mode:'local', "name":"d_tipoLanzVist","hiddenName":"d_tipoLanzVist","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
						      		, id: 'd_tipoLanzVist_id'+this.idFactoria
						      		, listeners:{select:function(combo){
						      		var idFactoria = combo.id.replace('d_tipoLanzVist_id','');
									var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionLanzVist'+idFactoria);
									var nuevaFechaSenyalamiento=Ext.getCmp('d_fecSenyNuevLanzVist'+idFactoria);
									var fechaSenySuspendida=Ext.getCmp('d_fecSenySuspLanzVist'+idFactoria);
									var fechaSenyAudPrev=Ext.getCmp('d_fecSenyLanzVist'+idFactoria);
									if(combo.getValue()=='SUSP'){
										plazoImpugnacion.setVisible(true);
										nuevaFechaSenyalamiento.setVisible(true);
										fechaSenySuspendida.setVisible(true);
										fechaSenyAudPrev.setVisible(false);
										}
									else{
										plazoImpugnacion.setVisible(false);
										nuevaFechaSenyalamiento.setVisible(false);
										fechaSenySuspendida.setVisible(false);
										fechaSenyAudPrev.setVisible(true);
										}
						      		}
						      	}}
						      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
						        	,displayField:'codigo',valueField:'id', "autoload":true
									, listeners:{select :function(combo){
										var idFactoria = combo.id.replace('d_nombreDemandado_id','');
										var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
										storeBienes.load({params:{idDemandado:combo.getValue()}});
									}
									}}
						      	,{"xtype":'numberfield',"name":"hidden3","fieldLabel":"oculto",allowBlank:true,  hidden:true}
						      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
						      	,{"xtype":'datefield',"name":"d_fecSenyLanzVist","fieldLabel":"Fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyLanzVist'+this.idFactoria, minValue: fechaMinima}
						      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionLanzVist'+this.idFactoria}
						      	,{"xtype":'datefield',"name":"d_fecSenySuspLanzVist","fieldLabel":"Fecha se&ntilde;alamiento suspendida",allowBlank:true, id:'d_fecSenySuspLanzVist'+this.idFactoria, hidden:true, minValue: fechaMinima}
						      	,{"xtype":'numberfield',"name":"hidden","fieldLabel":"oculto",allowBlank:true,  hidden:true}
						      	,{"xtype":'datefield',"name":"d_fecSenyNuevLanzVist","fieldLabel":"Nueva fecha se&ntilde;alamiento",allowBlank:true, id:'d_fecSenyNuevLanzVist'+this.idFactoria, hidden:true, minValue: fechaMinima}	      	
		]);
    	//id: 68 :ETJ: Lanzamiento : Resolución
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLanzRes","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolLanzRes","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Favorable", "Desfavorable"],"editable":"false",mode:'local', "name":"d_tipoLanzRes","hiddenName":"d_tipoLanzRes","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoLanzRes_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoLanzRes_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionLanzRes'+idFactoria);
								if(combo.getValue()=='Desfavorable'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionLanzRes'+this.idFactoria}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado", "hiddenName":"d_bienesDemandado","fieldLabel":"Bienes",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}      	
		]);
    	//id: 69 :ETJ: Lanzamiento: Impugnación Resolución
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionLanzImpRes","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolLanzImpRes","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Por Lindorff", "Por contrario"],"editable":"false",mode:'local', "name":"d_tipoLanzImpRes","hiddenName":"d_tipoLanzImpRes","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoLanzImpRes_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoLanzImpRes_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionLanzImpRes'+idFactoria);
								if(combo.getValue()=='Por contrario'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionLanzImpRes'+this.idFactoria}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}      	
		]);
    	// id: 70 ETJ:Depósito: Nombramiento depositario
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDepNomDep","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolReqDepNomDep","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Notificacion"],"editable":"false",mode:'local', "name":"d_tipoDepNomDep","hiddenName":"d_tipoDepNomDep","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'textfield',"name":"d_nombreDepositario","fieldLabel":"Depositario",allowBlank:true}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}      	
    	]);
    	// id: 71 ETJ:Depósito:Citación depositario
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDepCitDep","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolReqDepCitDep","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'datefield',"name":"d_fecCitacionDepCitDep","fieldLabel":"Fecha Citaci&oacute;n",allowBlank:false, minValue: fechaMinima}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'textfield',"name":"d_nombreDepositario","fieldLabel":"Depositario",allowBlank:true}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}      	
    	]);
    	// id: 72 ETJ:Depósito: Respuesta depositario
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDepRespDep","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolReqDepRespDep","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Acepta","Renuncia"],"editable":"false",mode:'local', "name":"d_tipoDepRespDep", "hiddenName":"d_tipoDepRespDep","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'textfield',"name":"d_nombreDepositario","fieldLabel":"Depositario",allowBlank:true}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}      	
    	]);
    	//id: 73 : ETJ: Depósito: Solicitud remoción
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDepSolRem","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolDepSolRem","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
		]);
    	
    	//id: 74 : ETJ: Depósito: Notificación acuerdo entrega bien
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionNotAcuBien","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolNotAcuBien","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'datefield',"name":"d_fecEntregaBien","fieldLabel":"Fecha entrega bien",allowBlank:false, minValue: fechaMinima}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'datefield',"name":"hidden","fieldLabel":"Oculto",allowBlank:true, hidden:true, minValue: fechaMinima}
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}
		]);
    	// id : 75 : ETJ :Precinto
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionPrec","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolPrec","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Solicitud","Favorable", "Desfavorable"],"editable":"false",mode:'local', "name":"d_tipoPrec","hiddenName":"d_tipoPrec","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id:'d_tipoPrec_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoPrec_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionPrec'+idFactoria);
								if(combo.getValue()=='Desfavorable'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'combo',"store":this.storeDemandados, width:'350', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado",id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
					        	,displayField:'codigo',valueField:'id', "autoload":true
								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_nombreDemandado_id','');
									var storeBienes= Ext.getCmp('d_bienesDemandado_id' + idFactoria).getStore();
									storeBienes.load({params:{idDemandado:combo.getValue()}});
								}
								}}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionPrec'+this.idFactoria}      	
					      	,{"xtype":'combo',"store": this.storeBienes, "name":"d_bienesDemandado","hiddenName":"d_bienesDemandado","fieldLabel":"Bien",allowBlank:false ,displayField:'codigo',valueField:'id', "autoload":true, mode:'local',triggerAction: 'all', id:'d_bienesDemandado_id' + this.idFactoria, resizable:true}      	
		]);
    	// id : 76 : CAMB: Demanda Oposición Cambiario
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionVistaDemCamb","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolVistaDemCamb","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true}      	
					      	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
							}
					      	,{"xtype":'datefield',"name":"d_fecVistaDemCamb","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:true, minValue: fechaMinima}		      	
		]);
    	// id : 77 : CAMB: Demanda Oposición Cambiario: Impugnación
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionVistaDemCambImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolVistaDemCambImp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
							}		      	
		]);
       	//id: 78 :ETJ: Demanda Oposición Cambiario: Sentencia
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDemCambRes","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolDemCambRes","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Favorable", "Desfavorable"],"editable":"false",mode:'local', "name":"d_tipoDemCambRes","hiddenName":"d_tipoDemCambRes","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id:'d_tipoDemCambRes_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoDemCambRes_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionDemCambRes'+idFactoria);
								if(combo.getValue()=='Desfavorable'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
							}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionDemCambRes'+this.idFactoria}
		]);
    	//id: 79 :ETJ: Demanda Oposición Cambiario: Recurso Sentencia
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionDemCambRecSen","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					      	,{"xtype":'datefield',"name":"d_fecRecepResolDemCambRecSen","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
					      	,{"xtype":'combo',"store":["Por contrario", "Por Lindorff"],"editable":"false",mode:'local', "name":"d_tipoDemCambRes","hiddenName":"d_tipoDemCambRes","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
					      		, id: 'd_tipoDemCambRes_id'+this.idFactoria
					      		, listeners:{select:function(combo){
					      		var idFactoria = combo.id.replace('d_tipoDemCambRes_id','');
								var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacionDemRecSen'+idFactoria);
								if(combo.getValue()=='Por contrario'){
									plazoImpugnacion.setVisible(true);
									}
								else{
									plazoImpugnacion.setVisible(false);
									}
					      		}
					      	}}
					      	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandado","hiddenName":"d_nombreDemandado", id:'d_nombreDemandado_id' + this.idFactoria,"fieldLabel":"Demandado",mode:'local',triggerAction: 'all',allowBlank:true
	                        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true
							}
					      	,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",allowBlank:true, hidden:true, id:'d_plazoImpugnacionDemRecSen'+idFactoria}
		]);
    	//id:80: ORDINARIO: ESPERAR/CONTINUAR
    	this.arrayCampos.push([{"xtype":'combo',"store":["Esperar", "Continuar"],"editable":"false",mode:'local', "name":"d_tipoEsperarContinuar","hiddenName":"d_tipoEsperarContinuar","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false}
					      		]);
    	//id:81: BO: Confirmar recepcion del contrato
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionConfRecepCnt","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       	,{"xtype":'datefield',"name":"d_fecRecepResolConfRecepCnt","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                       ,{"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_contratoRecibido","hiddenName":"d_contratoRecibido", id:'d_contratoRecibido_id', "fieldLabel":"Con/Sin testimonio",triggerAction: 'all',allowBlank:false}
					      		]);
    	//id:82: BO: Solicitud de testimonio
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionSolicitudTestimonio","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolSolicitudTestimonio","fieldLabel":"Fecha Solicitud",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                      	]);
    	//id:83: BO: Recepcion de testimonio
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionRecepcionTestimonio","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolRecepcionTestimonio","fieldLabel":"Fecha Recepci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                       ,{"xtype":'textfield',"name":"d_notario","fieldLabel":"Notario",allowBlank:false}
    	                       ,{"xtype":'textfield',"name":"d_protocolo","fieldLabel":"Protocolo",allowBlank:false}
    	                      	]);
    	//id:84: BO: Fichero tasas generado
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionGeneracionFichero","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolGeneracionFichero","fieldLabel":"Fecha Generaci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                      	]);
    	//id:85: BO: Validar fichero tasas
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionValidarFichero","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolValidarFichero","fieldLabel":"Fecha Validaci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                       ,{"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_tipoValidarFichero","hiddenName":"d_tipoValidarFichero","fieldLabel":"Fichero v&aacute;lido",triggerAction: 'all',allowBlank:false}
    	                       ]);
    	
    	//id:86: BO:Solicitud pago de tasas
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionSolicitudPago","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolSolicitudPago","fieldLabel":"Fecha Solicitud",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                       ]);
    	//id:87: BO: Recepcion documentacion tasas recibida
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionRecepcionPago","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolRecepcionPago","fieldLabel":"Fecha Recepci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                       ]);
    	//id:88: BO: Enviado a imprimir
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionEnviadoImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolEnviadoImp","fieldLabel":"Fecha enviado a imprimir",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                       ]);
    	//id:89: BO: Confirmar recepción documentación impresa
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionRecepDocImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolRecepDocImp","fieldLabel":"Fecha Recepci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                       ]);
    	//id:90: BO: Enviado al juzgado
    	this.arrayCampos.push([
    	                       	{"xtype":'datefield',"name":"d_fecResolucionEnviadoJuzgado","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	                       ,{"xtype":'datefield',"name":"d_fecRecepResolEnviadoJuzgado","fieldLabel":"Fecha Envio",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    	                       ,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
   								,autoSelect :true ,displayField:'descripcion',valueField:'codigo', "autoload":true
   								, listeners:{select :function(combo){
									var idFactoria = combo.id.replace('d_plaza_id','');
									var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
									var storeJuzgado= juzgado.getStore();
   									storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
									}
   								}}
    	                       ,{"xtype":'numberfield',"name":"d_numContrato","fieldLabel":"N&uacute;mero contrato",allowBlank:false}
      						 	,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado", "hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
    	                       ,{"xtype":'numberfield',"name":"d_numNova","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	                       ]);
    	// id: 91 :Solventar requerimiento previo
    	this.arrayCampos.push([
   	                       	{"xtype":'datefield',"name":"d_fecSolventarReqPrev","fieldLabel":"Fecha presentaci&oacute;n escrito",allowBlank:false, minValue: fechaMinima }
   	                     ]);
    	// id: 92 :Redaccion demanda etj
    	this.arrayCampos.push([
   	                       	{"xtype":'datefield',"name":"d_fecRedaccDemand","fieldLabel":"Fecha redacci&oacute;n demanda",allowBlank:false, minValue: fechaMinima }
   	                     ]);
    	// id: 93 :Acuerdo Extrajudicial
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecRecepAcuExtrajud", "fieldLabel":"Fecha Recepci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
      	,{"xtype":'multiselect',"store":this.storeDemandados, width:'150', "name":"d_nombreDemandadoExtrajud","hiddenName":"d_nombreDemandadoExtrajud", id:'d_nombreDemandadoExtrajud_id' + this.idFactoria,"fieldLabel":"Demandados",mode:'local',triggerAction: 'all',allowBlank:true
        	,displayField:'codigo',valueField:'id', "autoload":true, autoHeight:true}    					      	
    	,{"xtype":'combo',"store":["Acuerdo", "Homologacion"],"editable":"false",mode:'local', "name":"d_motivoAcuExtrajud","hiddenName":"d_motivoAcuExtrajud","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false
		      		, listeners:{select:function(combo){
					var fecPresenAcuExtrajud=combo.findParentByType(Ext.form.FormPanel).getForm().findField('d_fecPresenAcuExtrajud');
					if(combo.getValue()=='Homologacion'){
						fecPresenAcuExtrajud.setVisible(true);
						}
					else{
						fecPresenAcuExtrajud.setVisible(false);
						fecPresenAcuExtrajud.setValue('');
						}
		      		}
		      	}}
    	,{"xtype":'hidden',"name":"relleno", disabled:"true"}    	
	 	,{"xtype":'datefield',"name":"d_fecPresenAcuExtrajud", "fieldLabel":"Fecha Presentaci&oacute;n",allowBlank:true, hidden:true, minValue: fechaMinima}
		]);
    	// id: 94 :Lanzamiento ETJ desde FM
    	this.arrayCampos.push([
               	{"xtype":'numberfield',"name":"Num. Caso NOVA","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
               	,{"xtype":'numberfield',"name":"Principal demanda","fieldLabel":"Principal Demanda",allowBlank:false}
             ]);
     	// id: 95 :Generar doc. ini. BO SIN proc
    	this.arrayCampos.push([
               	{"xtype":'textfield',"name":"idAsunto","fieldLabel":"Id. Asunto",allowBlank:false}
             ]);
     	// id: 96 :Generar doc. ini. BO CON proc
    	this.arrayCampos.push([
               	{"xtype":'textfield',"name":"idAsunto","fieldLabel":"Id. Asunto",allowBlank:false}
             ]);
    	// id: 97 : Presentación demanda -MASIVO-
    	this.arrayCampos.push([
			{"xtype":'numberfield',"name":"Num. Caso NOVA","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
			,{"xtype":'numberfield',"name":"Principal demanda","fieldLabel":"Principal Demanda",allowBlank:false}
			,{"xtype":'datefield',"name":"d_fecPresentacionDemanda","fieldLabel":"Fecha Presentaci&oacute;n Demanda","format":"d/m/Y",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
			,{"xtype":'datefield',"name":"d_fecRecepPresentacionDemanda","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
		 ]);
    	//id:98 Requerimientos
    	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecResolucionReqAdmitido","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    							,{"xtype":'datefield',"name":"d_fecRecepResolReq","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    							,{"xtype":'combo',"editable":"false","store":this.storeRequerimientos ,mode:'local', "name":"d_tipoRequerimiento","hiddenName":"d_tipoRequerimiento",id:'d_tipoRequerimiento_id' + this.idFactoria
    								,"fieldLabel":"Tipo de Requerimiento",triggerAction: 'all',allowBlank:true,displayField:'descripcion',valueField:'codigo', "autoload":true }
    							,{"xtype":'numberfield',"name":"d_plazoResolucion","fieldLabel":"Plazo para solventar requerimiento",allowBlank:false }
    							,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza", "hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
    								,displayField:'descripcion',valueField:'codigo', "autoload":true
    								, listeners:{select :function(combo){
    									var idFactoria = combo.id.replace('d_plaza_id','');
    									var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
    									var storeJuzgado= juzgado.getStore();
    									storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
									}
    								}}
    							,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado","hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
       						 	]);
    	// id: 99 :Solventar requerimiento
    	this.arrayCampos.push([
   	                       	{"xtype":'datefield',"name":"d_fecSolventarReq","fieldLabel":"Fecha presentaci&oacute;n escrito",allowBlank:false, minValue: fechaMinima }
   	                     ]);
    	
    	// id: 100 :Admisión de la demanda - BATCH
    	this.arrayCampos.push([
    	 {"xtype":'numberfield',"name":"Num. Caso NOVA","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
		,{"xtype":'datefield',"name":"d_fecResolucionDemanda","fieldLabel":"Fecha de admisi&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		,{"xtype":'datefield',"name":"d_fecRecepResolDemanda","fieldLabel":"Fecha recepci&oacute;n demanda",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
		,{"xtype":'combo',"store":["Total","Parcial"],"editable":"false",mode:'local', "name":"d_demandaTotal", "hiddenName":"d_demandaTotal","fieldLabel":"Total / Parcial",triggerAction: 'all',allowBlank:true
			, id: 'd_demandaTotal_id'+this.idFactoria
			, listeners:{select:function(combo){
				var idFactoria = combo.id.replace('d_demandaTotal_id','');
				var plazoImpugnacionAdmmision=Ext.getCmp('d_plazoImpugnacion'+idFactoria);
					if(combo.getValue()=='Parcial'){
						plazoImpugnacionAdmmision.setVisible(true);
						}
					else{
						plazoImpugnacionAdmmision.setVisible(false);
					}
				}
			}
		}
		,{"xtype":'numberfield',"name":"d_cuantiaDemandada","fieldLabel":"Cuant&iacute;a demandada",allowBlank:false }
		,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
			,displayField:'descripcion',valueField:'codigo', "autoload":true
			, listeners:{select :function(combo){
				var idFactoria = combo.id.replace('d_plaza_id','');
				var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
				var storeJuzgado= juzgado.getStore();
				storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
			}
			}}
		 ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado","hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
		 ,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",hidden:true, allowBlank:true, id:"d_plazoImpugnacion"+this.idFactoria}
		 ]);
    
    
    
    	// id: 101 :Admisión de la demanda (Autodespachando ejecucion) - BATCH
    	this.arrayCampos.push([
    	 {"xtype":'numberfield',"name":"Num. Caso NOVA","fieldLabel":"N&uacute;mero caso NOVA",allowBlank:false}
    	,{"xtype":'datefield',"name":"d_fecResolucionAude","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
       	,{"xtype":'datefield',"name":"d_fecRecepResolAude","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       	,{"xtype":'combo',"store":["Total","Parcial"],"editable":"false",mode:'local', "name":"d_tipoAude","hiddenName":"d_tipoAude","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true
       		, id: 'd_tipoAude_id'+this.idFactoria
       		, listeners:{select:function(combo){
       		var idFactoria = combo.id.replace('d_tipoAude_id','');
 			var plazoImpugnacion=Ext.getCmp('d_plazoImpugnacion'+idFactoria);
 			if(combo.getValue()=='Parcial'){
 				plazoImpugnacion.setVisible(true);
 				}
 			else{
 				plazoImpugnacion.setVisible(false);
 				}
       		}
       	}}
		,{"xtype":'numberfield',"name":"d_cuantiaDemandada","fieldLabel":"Cuant&iacute;a demandada",allowBlank:false }
		,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
			,displayField:'descripcion',valueField:'codigo', "autoload":true
			, listeners:{select :function(combo){
				var idFactoria = combo.id.replace('d_plaza_id','');
				var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
				var storeJuzgado= juzgado.getStore();
				storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
			}
			}}
		 ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado","hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
		 ,{"xtype":'numberfield',"name":"d_plazoImpugnacion","fieldLabel":"Plazo de impugnaci&oacute;n",hidden:true, allowBlank:true, id:"d_plazoImpugnacion"+this.idFactoria}
		 ]);
    	// id: 102 :Escrito de la otra parte presentando solicitud de tasacion de costas
    	this.arrayCampos.push([
    	{"xtype":'datefield',"name":"d_fecResolucionSolTasCosContrario","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolSolTasCosContrario","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	]);
    	// id: 103 :Diligencia de ordenación
    	this.arrayCampos.push([
    	{"xtype":'datefield',"name":"d_fecResolucionDiligOrden","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolDiligOrden","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	]);
    	// id: 104 :Escrito alegando impugnación
    	this.arrayCampos.push([
    	{"xtype":'datefield',"name":"d_fecResolucionEscrAlegImp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolEscrAlegImp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	,{"xtype":'combo',"store":["Excesiva","Indebida"],"editable":"false",mode:'local', "name":"d_tipoEscrAlegImp","hiddenName":"d_tipoEscrAlegImp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:true}
    	,{"xtype":'combo',"store":["Lindorff","Contrario"],"editable":"false",mode:'local', "name":"d_lindorffContEscrAlegImp","hiddenName":"d_lindorffContEscrAlegImp","fieldLabel":"Lindorff/Contrario",triggerAction: 'all',allowBlank:true}
    	]);
    	// id: 105 :Decreto aprobando tasacion de costas
    	this.arrayCampos.push([
    	{"xtype":'datefield',"name":"d_fecResolucionDecAprobTasCos","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolDecAprobTasCos","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	]);
    	// id: 106 :Demanda de ETJ / decreto embargo
    	this.arrayCampos.push([
    	{"xtype":'datefield',"name":"d_fecResolucionDemEtjDecEmb","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolDemEtjDecEmb","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	]);
    	// id: 107 :Diligencia de Ordenacion + escrito aportando justificante de pago
    	this.arrayCampos.push([
    	{"xtype":'datefield',"name":"d_fecResolucionDilOrdJustPag","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolDilOrdJustPag","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	]);
    	// id: 108 :Suspensión de la vista costas
    	this.arrayCampos.push([
    	{"xtype":'datefield',"name":"d_fecResolucionSuspVistCost","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolSuspVistCost","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	,{"xtype":'datefield',"name":"d_fecNuevSeny","fieldLabel":"Nueva fecha se&ntilde;alamiento: ",allowBlank:true, minValue: fechaMinima }
    	]);
    	// id: 109 :Decreto señalando vista 
    	this.arrayCampos.push([
    	{"xtype":'datefield',"name":"d_fecResolucionDecSenyVista","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolDecSenyVista","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	,{"xtype":'datefield',"name":"d_fecNuevSeny","fieldLabel":"Nueva fecha se&ntilde;alamiento: ",allowBlank:true, minValue: fechaMinima }
    	]);
    	// RESOLUCIONES PARA EL PROCEDIMIENTO CONCURSAL
    	// id: 110 :Solicitud de declaración Concurso
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionSolDecConcurs","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	 ,{"xtype":'datefield',"name":"d_fecRecepResolSolDecConcurs","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	 ,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
				,autoSelect :true ,displayField:'descripcion',valueField:'codigo', "autoload":true
				, listeners:{select :function(combo){
					var idFactoria = combo.id.replace('d_plaza_id','');
					var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
					var storeJuzgado= juzgado.getStore();
					storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
				}
				}}
		 ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado", "hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
    	 ]);
    	// id : 111 :Escrito Auto declarando Concurso
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionAutDeclConcurs","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolAutDeclConcurs","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	,{"xtype":'combo',"store":["Abreviado","Ordinario"],"editable":"false",mode:'local', "name":"d_tipoAutDeclConcurs","hiddenName":"d_tipoAutDeclConcurs","fieldLabel":"Abreviado/Ordinario",triggerAction: 'all',allowBlank:true}
    	,{"xtype":'combo',"store":["Voluntario","Necesario"],"editable":"false",mode:'local', "name":"d_tipoDeclVoluntNeces","hiddenName":"d_tipoDeclVoluntNeces","fieldLabel":"Voluntario/Necesario",triggerAction: 'all',allowBlank:true}
    	]); 
    	// id : 112 :Registrar Publicación en el BOE
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionRegPublBOE","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolRegPublBOE","fieldLabel":"Fecha Publicaci&oacute;n BOE",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
			,autoSelect :true ,displayField:'descripcion',valueField:'codigo', "autoload":true
			, listeners:{select :function(combo){
				var idFactoria = combo.id.replace('d_plaza_id','');
				var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
				var storeJuzgado= juzgado.getStore();
				storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
			}
			}}
	    ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado", "hiddenName":"d_juzgado","fieldLabel":"Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
	    ,{"xtype":'numberfield',"name":"d_numeroRegPublicBOE","fieldLabel":"N&uacute;mero registro",allowBlank:true}
	    ]); 
    	// id : 113 :Escrito de personación
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionEscPersonac","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolEscPersonac","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]); 
    	// id : 114 :Comunicación de la administración concursal
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionComAdmtConcurs","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolComAdmtConcurs","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]); 
    	// id : 115 :Escrito de comunicación de créditos a la administración concursal
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionComCredAdmtConcurs","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolComCredAdmtConcurs","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id : 116 :Insuficiencia masa activa
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionInsufMasaAct","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolInsufMasaAct","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id : 117 :Proyecto de informe
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionProyInforme","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolProyInforme","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id : 118 :Informe Administración concursal
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionInfAdmConcurs","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolInfAdmConcurs","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	,{"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_alegInfAdmConcurs","hiddenName":"d_alegInfAdmConcurs","fieldLabel":"Con alegaciones",triggerAction: 'all',allowBlank:false }
    	]);
    	// id : 119 :Auto (Liquidación)
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionAutoLiquidacion","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolAutoLiquidacion","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id : 120 Sentencia desestimación
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionSentDesestConc","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolSentDesestConc","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id : 121 Escrito de allanamiento
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionEscAllan","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolEscAllan","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id : 122: Escrito de oposición
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionEscOpo","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolEscOpo","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 123 :Resulado de la vista
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionResultVista","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolResultVista","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 124 :Sentencia definitiva
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionSentDefinConc","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolSentDefinConc","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 125 :Registrar textos definitivos
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionRegTextDefin","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolRegTextDefin","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 126 :Auto (Convenio)
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionAutoConvenio","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolAutoConvenio","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 127 :Registro propuesta
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionRegisPropuesta","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolRegisPropuesta","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 128 :Resultado de la propuesta
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionResultProp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolResultProp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	,{"xtype":'combo',"store":["Favorable","Desfavorable"],"editable":"false",mode:'local', "name":"d_tipoResultProp","hiddenName":"d_tipoResultProp","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false}
    	]);
    	// id: 129 :Sentencia aprobando propuesta
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionSentAprobProp","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolSentAprobProp","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 130 :Auto de apertura de fase de liquidación
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionApertFaseLiquid","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolApertFaseLiquid","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 131 :Registro de informe trimestral u otras resoluciones
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionRegInfTrimest","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolRegInfTrimest","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 132 :Cobro
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionCobro","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolCobro","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 133 :Informe con resultado
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionInformeConResult","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolInformeConResult","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	,{"xtype":'combo',"store":["Incumplimiento","Cumplimiento" ,"Fin de seguimiento"],"editable":"false",mode:'local', "name":"d_tipoInformeConResult","hiddenName":"d_tipoInformeConResult","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false}
    	]);
    	// id: 134 :Informe indicando la sección de calificación
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionInfSeccCalif","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolInfSeccCalif","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	,{"xtype":'combo',"store":["Culpable","Fortuito"],"editable":"false",mode:'local', "name":"d_tipoInfSeccCalif","hiddenName":"d_tipoInfSeccCalif","fieldLabel":"Tipo",triggerAction: 'all',allowBlank:false}
    	]);
    	// id: 135 :Envio demanda
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecEnvioDemanda","fieldLabel":"Fecha Envio Demanda",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }    	
    	]);
    	// A PARTIR DE AQUÍ RESERVADOS TODOS LOS IDS PARA EL HIPOTECARIO
    	// EN DESARROLLO - HABLAR CON GUILLEM
    	// id: 136 : HIPOTECARIO : Interposición demanda
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecInterposicionDemanda","fieldLabel":"Fecha Interposici&oacute;n Demanda",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
		,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
				,autoSelect :true ,displayField:'descripcion',valueField:'codigo', "autoload":true
				, listeners:{select :function(combo){
					var idFactoria = combo.id.replace('d_plaza_id','');
					var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
					var storeJuzgado= juzgado.getStore();
					storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
				}
		 }}		
		 ,{"xtype":'numberfield',"name":"d_valorTasacion","fieldLabel":"Valor de tasaci&oacute;n",allowBlank:true, id:'d_valorTasacion'+this.idFactoria}
		 ,{"xtype":'numberfield',"name":"d_valorResponsabilidadHipotecaria","fieldLabel":"Valor de Responsabilidad Hipotecaria",allowBlank:true, id:'d_valorResponsabilidadHipotecaria'+this.idFactoria}
    	]);
    	// id: 137 : HIPOTECARIO : Auto despachando ejecución
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecAutoDespachandoEjecucion","fieldLabel":"Fecha Auto Despachando Ejecuci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
 		,{"xtype":'combo',"editable":"false","store":app.plazas,mode:'local', "name":"d_plaza","hiddenName":"d_plaza",id:'d_plaza_id' + this.idFactoria,"fieldLabel":"Plaza",triggerAction: 'all',allowBlank:false
			,autoSelect :true ,displayField:'descripcion',valueField:'codigo', "autoload":true
			, listeners:{select :function(combo){
				var idFactoria = combo.id.replace('d_plaza_id','');
				var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
				var storeJuzgado= juzgado.getStore();
				storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
			}
		}}
 	 	,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_juzgado", "hiddenName":"d_juzgado","fieldLabel":"N&uacute;mero Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
 	 	,{"xtype":'numberfield',"name":"d_numeroProcedimiento","fieldLabel":"N&uacute;mero Procedimiento",allowBlank:true, id:'d_valorTasacion'+this.idFactoria}
 	 	,{"xtype":'combo',"store": ["SI", "NO"], "name":"d_admision","fieldLabel":"Admisi&oacute;n","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_admision'+this.idFactoria}
    	]);
    	// id: 138 : HIPOTECARIO : Solicitar instrucciones a la entidad
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecSolicitarInstruccionesDemanda","fieldLabel":"Fecha Solicitud Instrucciones Demanda",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }    	
    	]);
    	// id: 139 : HIPOTECARIO : Registrar instrucciones a la entidad
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecRegistrarInstruccionesDemanda","fieldLabel":"Fecha Registro Instrucciones Demanda",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }    	
    	]);
    	// id: 140 : HIPOTECARIO : Certificación de cargas
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecCertificacionCargas","fieldLabel":"Fecha Certificaci&oacute;n Cargas",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }    	
    	]);
    	// id: 141 : HIPOTECARIO : Confirmar notificación del auto despachando ejecución
    	this.arrayCampos.push([
    	 {"xtype":'combo',"store": ["SI", "NO"], "name":"d_resultadoNotificacion","fieldLabel":"Resultado Notificaci&oacute;n","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_resultadoNotificacion'+this.idFactoria}    	                       
    	,{"xtype":'datefield',"name":"d_fecNotificacionAutoDespachandoEjecucion","fieldLabel":"Fecha Notificaci&oacute;n Auto Despachando Ejecuci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }    	
    	]);
    	// id: 142 : HIPOTECARIO : Confirmar notificacion a todos los demandados
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionRequerimientoCobro","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolRequerimientoCobro","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	// id: 143 : HIPOTECARIO : Confirmar si existe oposición
    	this.arrayCampos.push([
	     {"xtype":'combo',"store": ["SI", "NO"], "name":"d_existeOposicion","fieldLabel":"Existe Oposici&oacute;n","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_existeOposicion'+this.idFactoria}
    	,{"xtype":'datefield',"name":"d_fecOposicion","fieldLabel":"Fecha Oposici&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'combo',"store": ["Ordinaria", "Clausulas abusivas", "Cláusula túnel"], "name":"d_tipoOposicion","fieldLabel":"Tipo Oposici&oacute;n","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_tipoOposicion'+this.idFactoria}
    	,{"xtype":'combo',"store": ["SI", "NO"], "name":"d_existeComparecencia","fieldLabel":"Existe Comparecencia","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_existeComparecencia'+this.idFactoria}
    	,{"xtype":'datefield',"name":"d_fecComparecencia","fieldLabel":"Fecha Comparecencia",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	]);
    	// id: 144 : HIPOTECARIO : Registrar comparecencia
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecRegistrarComparecencia","fieldLabel":"Fecha Registro Comparecencia",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }    	
    	]);
    	// id: 145 : HIPOTECARIO : Registrar resolución
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecRegistrarResolucion","fieldLabel":"Fecha Registro Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'combo',"store": ["Favorable", "Desfavorable", "Est. Parcial"], "name":"d_resultado","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_resultado'+this.idFactoria} 
    	]);
    	// id: 146 : HIPOTECARIO : Resolución firme
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucioniFirme","fieldLabel":"Fecha Resoluci&oacute;n Firme",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
     	,{"xtype":'combo',"store": ["Favorable", "Desfavorable", "Est. Parcial"], "name":"d_resultadoResolucionHip","fieldLabel":"Resultado","autoload":true, hidden:true, mode:'local',triggerAction: 'all',resizable:true, id:'d_resultadoResolucionHip'+this.idFactoria
     		,listeners:{afterRender:function(combo){
     			Ext.Ajax.request({
					url: '/pfs/lininput/obtenerDatoInput.htm'
					,params: {idProcedimiento: this.findParentByType(Ext.form.FormPanel).getForm().findField('idProcedimiento').getValue(), nombreCampoInput: 'resultado'}
					,method: 'POST'
					,success: function (result, request){
						if(result != null && result.responseText != null){
							var r = Ext.util.JSON.decode(result.responseText);
							if(r.resultado != null){combo.setValue(r.resultado);}
						}
					}});
     			}
     		}
     	}
    	]);
    	// id: 147 : HIPOTECARIO : Enviar informe a la entidad
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecEnviarInformeEntidad","fieldLabel":"Fecha Envio Informe a la Entidad",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }    	
    	]);
    	// id: 148 : HIPOTECARIO : Registrar instrucciones a la entidad
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecRegistrarInstruccionesEntidad","fieldLabel":"Fecha Registro Instrucciones Entidad",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }    	
    	]);
    	    	
    	
    	// A PARTIR DE AQUÍ RESERVADOS TODOS LOS IDS PARA EL TRÁMITE ADJUDICACIÓN
    	// EN DESARROLLO - HABLAR CON VICENTE
    	// id: 149 : TRÁMITE ADJUDICACIÓN : Solucitud Auto Adjudicación
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecSolicitud","fieldLabel":"Fecha Solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	]);
    	// id: 150 : TRÁMITE ADJUDICACIÓN : Notificación decreto de Adjudicación a la Entidad
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       	,{"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_conforme","fieldLabel":"Conforme",allowBlank:false }
        ,{"xtype":'textfield',"name":"d_importeAdjudicacion","fieldLabel":"Importe Adjudicaci&oacute;n (Precarga el dato desde subasta)",allowBlank:false}
      	,{"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_subsanacion","fieldLabel":"Subsanaci&oacute;n  Si/No",allowBlank:false }
        ]);
    	// id: 151 : TRÁMITE ADJUDICACIÓN : Notificación decreto de Adjudicación al Contrario
    	this.arrayCampos.push([
       	 {"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_notificado","fieldLabel":"Notificado Si/No",allowBlank:false },
    	 {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	]);
    	// id: 152 : TRÁMITE ADJUDICACIÓN :  Confirmar Testimonio Decreto de Adjudicación
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  },
	     {"xtype":'numberfield',"name":"d_cuantiaAdjudicacion","fieldLabel":"Cuant&iacute;a Adjudicaci&oacute;n",allowBlank:false },					         
	    // {"xtype":'checkbox',boxLabel: 'Mandamiento',name: 'd_mandamiento',inputValue: 'mandamiento',value:false}
       	 {"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_subsanacion","fieldLabel":"Subsanaci&oacute;n  Si/No",allowBlank:false },
       	 {"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_mandamiento","fieldLabel":"Mandamiento Si/No",allowBlank:false }
    	]);
    	// id: 153 : TRÁMITE ADJUDICACIÓN : Confirmar Pago Impuesto
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fechaVencimientoLiquidacion","fieldLabel":"Fecha vencimiento liquidaci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  },
	     {"xtype":'numberfield',"name":"d_importeImpuesto","fieldLabel":"Importe impuesto",allowBlank:false }		
    	]);
    	// id: 154 : TRÁMITE ADJUDICACIÓN : Confirmar inscripción y cancelación de cargas
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecInscripcion","fieldLabel":"Fecha Inscripci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  },
       	 {"xtype":'combo',"store":["SI", "NO"],"editable":"false",mode:'local', "name":"d_canceladasCargas","fieldLabel":"Canceladas cargas Si/No",allowBlank:false }
    	]);
    	// id: 155 : TRÁMITE ADJUDICACIÓN : Confirmar notificacion a todos los demandados
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fecResolucionRequerimientoCobro","fieldLabel":"Fecha Resoluci&oacute;n",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }
    	,{"xtype":'datefield',"name":"d_fecRecepResolRequerimientoCobro","fieldLabel":"Fecha Recepci&oacute;n Resoluci&oacute;n",allowBlank:false,value: new Date(), maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y') }
    	]);
    	//TRAMITE GESTION LLAVES LINDORFF
    	// id: 156 : TRAMITE GESTION LLAVES LINDORFF : Registrar cambio cerradura
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fechaCambioCerradura","fieldLabel":"Fecha cambio de cerradura",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    	]);
    	// id:157: TRAMITE GESTION LLAVES LINDORFF : Registrar envio de llaves
    	this.arrayCampos.push([
    	 {"xtype":'textfield',"name":"d_nombreDepositario","fieldLabel":"Nombre del depositario",allowBlank:false},
    	 {"xtype":'datefield',"name":"d_fechaEnvioLLaves","fieldLabel":"Fecha env&iacute;o",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }		
    	]);
    	// id:158: TRAMITE GESTION LLAVES LINDORFF : Registrar recepción de llaves
    	this.arrayCampos.push([
    	 {"xtype":'datefield',"name":"d_fechaRecepcionDepositario","fieldLabel":"Fecha recepci&oacute;n depositario",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima  }		
    	]);
    	
    }
	

});