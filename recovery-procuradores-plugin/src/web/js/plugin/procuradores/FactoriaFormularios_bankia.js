Ext.ns("es.pfs.plugins.procuradores");
//"store":this.dsPlazas
//"store":app.plazas
var codigoPlaza = "01-001";
var decenaInicio = 0;

var dataSINO = '[{"descripcion":"SI", "codigo":"01"},{"descripcion":"NO", "codigo":"02"}]';
var storeSINO = new Ext.data.JsonStore({
    				fields: [
    				         {type: 'string', name: 'descripcion'},
    				         {type: 'string', name: 'codigo'}
    				         ]
	});
storeSINO.loadData(Ext.decode(dataSINO));

es.pfs.plugins.procuradores.FactoriaFormularios = Ext.extend(Object,{  //Step 1  
    
	attrb: "att1",  
	formulario: "form",
	arrayCampos: [],
	idAsunto:"",
	idProcedimiento:"",
	dsPlazas:{},
	dsProcedimiento:{},
	storeRequerimientos:{},
	storeMotivosInadmision:{},
	storeMotivosArchivo:{},
	storeMotivosProrroga:{},
//	storeDemandados:{},
//	storeDomicilios:{},
//	storeBienes:{},
	dsJuzgado:{},
	dsDatosAdicionales:{},
	codigoProcedimiento:"",
	idFactoria: "",
	storeMotivosSuspension:{},
	storeDecisionSuspension:{},
	storeEntidadAdjudicataria:{},
	storeFondo:{},
	storeMotivoImpugnacion:{},
	storeDDFavorable:{},
	storeCompletitud:{},
	storeDDPositivoNegativo:{},
	storeDDCorrectoCobro:{},
    
    constructor : function(options){    //Step 2  
    	Date.now = Date.now || function() { return +new Date; };
    	Ext.apply(this,options || {idFactoria: Date.now(), arrayCampos: []});
        this.initArrays(this.idFactoria);
    },
    

    updateStores: function(){
    	this.dsPlazas.load({params:{idFactoria:this.idFactoria, dsProcedimiento:this.dsProcedimiento}});    	
    	this.dsProcedimiento.load({params:{idFactoria:this.idFactoria, idProcedimiento:this.idProcedimiento}});
    	this.storeRequerimientos.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivosInadmision.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivosProrroga.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivosArchivo.load({params:{idFactoria:this.idFactoria}});
//    	this.storeDemandados.load({params:{idProcedimiento:this.idProcedimiento, idFactoria:this.idFactoria}});
    	this.dsDatosAdicionales.load({params:{idProcedimiento:this.idProcedimiento}});
    	this.storeMotivosSuspension.load({params:{idFactoria:this.idFactoria}});
    	this.storeDecisionSuspension.load({params:{idFactoria:this.idFactoria}});
    	this.storeEntidadAdjudicataria.load({params:{idFactoria:this.idFactoria}});
    	this.storeFondo.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivoImpugnacion.load({params:{idFactoria:this.idFactoria}});
    	this.storeDDFavorable.load({params:{idFactoria:this.idFactoria}});
    	this.storeCompletitud.load({params:{idFactoria:this.idFactoria}});
    	this.storeDDPositivoNegativo.load({params:{idFactoria:this.idFactoria}});
    	this.storeDDCorrectoCobro.load({params:{idFactoria:this.idFactoria}});
    	
    },
    
    getFormItems: function(idTipoResolucion, idAsunto, codigoProcedimiento, codPlaza,idProcedimiento, filtrar){
    	//debugger;
    	this.idAsunto=idAsunto;
    	this.codigoProcedimiento=codigoProcedimiento;
    	codigoPlaza=codPlaza;
    	this.idProcedimiento=idProcedimiento;
    	   	
    	var campos = null;
    	campos = this.arrayCampos[idTipoResolucion];
// lo comentamos porque de momento no se va a usar.    	
//    	if (filtrar){
//    		for (var i=0;i<campos.length;i++){
//    			if(campos[i].filtrar){
//    				campos[i].hidden=true;
//    				campos[i].allowBlank=true;
//    			}
//    		}
//    	}

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
    	
    	var esResolEspecial = true;
    	if( idTipoResolucion < 1000 ){esResolEspecial = false;}
    	
    	var items = [{colspan:2, width:800, style:'padding-top:0px;padding-bottom:0px',
			items:[{"xtype":'textfield',"name":"d_numAutos","fieldLabel":"N&uacute;mero de autos",allowBlank:function(idTipoResolucion){idTipoResolucion==1 || idTipoResolucion==92 || idTipoResolucion==135},
				id:'d_numAutos_id' + this.idFactoria, hidden:true
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
				items:	[ 
				      	  	{"xtype":'displayfield',"name":"file","id":"file","fieldLabel":"Fichero","value":"No se ha adjuntado ning&uacute;n fichero.",allowBlank:false,width:500}
				      	  	,{"xtype": 'textfield', "id": 'file_upload_ok',"name": 'file_upload_ok',"value": "",allowBlank:esResolEspecial,hidden:true}
						]
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
    	
    	//COMENTADO CARLOS
    	this.dsPlazas = new Ext.data.Store({
    		autoLoad: false,
    		baseParams: {limit:10, start:0},
    		url:'/pfs/plugin/procedimientos/plazasDeJuzgados.htm',
    		actionMethods: {
    			create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'
    			},
    		reader: new Ext.data.JsonReader({
    			root: 'plazas'
    			,totalProperty: 'total'
    		}, [
    			{name: 'codigo', mapping: 'codigo'},
    			{name: 'descripcion', mapping: 'descripcion'}
    		])
    	});
    	
//    	var dsPlazasRecord = Ext.data.Record.create([
//    	                                          		 {name:'codigo'}
//    	                                          		,{name:'descripcion'}
//    	                                          	]);
//    	                                          	
//      	this.dsPlazas = page.getStore({
//      		flow:'/pfs/plugin/procedimientos/plazasDeJuzgados.htm'
//      		,reader: new Ext.data.JsonReader({
//      			root:'plazas'
//      			,totalProperty: 'total'
//      		},dsPlazasRecord)
//      	});
    	
    	

    	
//    	if (app.plazas == undefined) {
//    		
//    		var plazasRecordGlobal = Ext.data.Record.create([
//    	    	                                        	 {name:'id'}
//    	    	                                        	,{name:'codigo'}
//    														,{name:'descripcion'}
//    														 ]);
//    		
//    		app.plazas = new Ext.data.Store({
//    	    		url:'/pfs/pcdprocesadoresoluciones/getPlazas.htm'
//    	    		,reader: new Ext.data.JsonReader({
//    	    			root : 'plazas'
//    	    		} , plazasRecordGlobal)
//    	    	});
//
//    		app.plazas.load();
//    	}
    	
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
    		url:'/pfs/pcdprocesadoresoluciones/getProcedimiento.htm'
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
    		,url:'/pfs/pcdprocesadoresoluciones/getJuzgadosByPlaza.htm'
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
    		url:'/pfs/pcdprocesadoresoluciones/getTiposRequerimiento.htm'
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
    		url:'/pfs/pcdprocesadoresoluciones/getMotivosInadmision.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'motivos'
        		} , motivosRecord)
        	});
    	
    	var motivosArchivoRecord = Ext.data.Record.create([
	    	                                        	{name:'codigo'}
														,{name:'descripcion'}
														 ]);
    	
    	this.storeMotivosArchivo= new Ext.data.Store({
    		url:'/pfs/pcdprocesadoresoluciones/getMotivosArchivo.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'motivos'
        		} , motivosArchivoRecord)
        	});
    	
    	
    	//Prorroga
    	
    	//Motivos de la prórroga
    	var motivosProrrogaRecord = Ext.data.Record.create([
    	                                              {name:'codigo'}
    	                                              ,{name:'descripcion'}
    	                                              ]);
    	
    	this.storeMotivosProrroga= new Ext.data.Store({
    		url:'/pfs/pcdprocesadoresoluciones/getMotivosProrroga.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'motivos'
        		} , motivosProrrogaRecord)
        	});
    	
    	
    	// demandados
//    	var demandadosRecord = Ext.data.Record.create([
//      	    	                                        	{name:'id'}
//      														,{name:'codigo'}
//      														 ]);
//    	this.storeDemandados= new Ext.data.Store({
//    		url:'/pfs/pcdprocesadoresoluciones/getDemandadosProcedimiento.htm'
//        		,reader: new Ext.data.JsonReader({
//        			root : 'demandados'
//        		} , demandadosRecord)
//        	});
    	
    	// domicilios demandados
//    	var domiciliosRecord = Ext.data.Record.create([
//      	    	                                        	{name:'id'}
//      														,{name:'codigo'}
//      														 ]);
//    	this.storeDomicilios= new Ext.data.Store({
//    		url:'/pfs/pcdprocesadoresoluciones/getDomiciliosDemandados.htm'
//        		,reader: new Ext.data.JsonReader({
//        			root : 'domicilios'
//        		} , domiciliosRecord)
//        	});
    	
    	// bienes de demandados
//    	var bienesRecord = Ext.data.Record.create([
// 	    	                                        	{name:'id'}
// 														,{name:'codigo'}
// 														 ]);
//    	this.storeBienes= new Ext.data.Store({
//    		url:'/pfs/pcdprocesadoresoluciones/getBienesDemandado.htm'
//        		,reader: new Ext.data.JsonReader({
//        			root : 'bienes'
//        		} , bienesRecord)
//        	});
    	
    	var datosAdicionalesRecord = Ext.data.Record.create([
    	                                                     {name : 'conTestimonio'} 
    	                                                    ]);

		this.dsDatosAdicionales = new Ext.data.Store({
					url : '/pfs/pcdprocesadoresoluciones/getDatosAdicionales.htm'
						,reader : new Ext.data.JsonReader({
							root : 'datosAdicionales'
						}, datosAdicionalesRecord)
				});



	////Motivos suspension 
    	var motivosSuspensionRecord = Ext.data.Record.create([
      	    	                                        	{name:'codigo'}
      														,{name:'descripcion'}
      														 ]);


    	this.storeMotivosSuspension= new Ext.data.Store({
    		url:'/pfs/pcdprocesadoresoluciones/getMotivosSuspension.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'motivosSuspensionSubasta'
        		} , motivosSuspensionRecord)
        	});

	///Decision suspension

    	var decisionSuspensionRecord = Ext.data.Record.create([
      	    	                                        	{name:'codigo'}
      														,{name:'descripcion'}
      														 ]);


    	this.storeDecisionSuspension= new Ext.data.Store({
    		url:'/pfs/pcdprocesadoresoluciones/getDecisionSuspension.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'decisionSuspensionSubasta'
        		} , decisionSuspensionRecord)
        	});


	/////Entidad Adjudicataria
    	var decisionEntidadAdjudicatoriaRecord = Ext.data.Record.create([
      	    	                                        	{name:'codigo'}
      														,{name:'descripcion'}
      														 ]);


    	this.storeEntidadAdjudicataria= new Ext.data.Store({
    		url:'/pfs/pcdprocesadoresoluciones/getEntidadesAdjudicatorias.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'entidadesAdjudicatorias'
        		} , decisionEntidadAdjudicatoriaRecord)
        	});
	
	/////Tipo fondo
    	var decisionFondoRecord = Ext.data.Record.create([
      	    	                                        	{name:'codigo'}
      														,{name:'descripcion'}
      														 ]);


    	this.storeFondo= new Ext.data.Store({
    		url:'/pfs/pcdprocesadoresoluciones/getTiposFondo.htm'
        		,reader: new Ext.data.JsonReader({
        			root : 'tiposFondo'
        		} , decisionFondoRecord)
        	});
    	
    /////Motivo impugnacion
    var motivoImpugnacionRecord = Ext.data.Record.create([
                                                          	{id:'id'}
    	    	                                        	,{name:'codigo'}
    														,{name:'descripcion'}
    														 ]);


  	this.storeMotivoImpugnacion= new Ext.data.Store({
  		url:'/pfs/pcdprocesadoresoluciones/getMotivosImpugnacion.htm'
      		,reader: new Ext.data.JsonReader({
      			root : 'motivosImpugnacion'
      		} , motivoImpugnacionRecord)
      	});
    	

  	////Motiv Favorable
    var motivoDDFavorableRecord = Ext.data.Record.create([
                                                        	{id:'id'}
  	    	                                        	,{name:'codigo'}
  														,{name:'descripcion'}
  														 ]);


	this.storeDDFavorable= new Ext.data.Store({
		url:'/pfs/pcdprocesadoresoluciones/getMotivosRegistroResolucionFavorables.htm'
    		,reader: new Ext.data.JsonReader({
    			root : 'motivosFavorables'
    		} , motivoDDFavorableRecord)
    	});
	
	
	
  	////Store DDCompletitud
    var DDCompletitudRecord = Ext.data.Record.create([
                                                        	{id:'id'}
  	    	                                        	,{name:'codigo'}
  														,{name:'descripcion'}
  														 ]);


	this.storeCompletitud= new Ext.data.Store({
		url:'/pfs/pcdprocesadoresoluciones/getDDCompletitudes.htm'
    		,reader: new Ext.data.JsonReader({
    			root : 'ddCompletitudes'
    		} , DDCompletitudRecord)
    	});
	
	
	///store DDPositivoNegativo
    var DDPositivoNegativo = Ext.data.Record.create([
                                                  	{id:'id'}
    	                                        	,{name:'codigo'}
													,{name:'descripcion'}
													 ]);


    this.storeDDPositivoNegativo= new Ext.data.Store({
	url:'/pfs/pcdprocesadoresoluciones/getDDPositivoNegativo.htm'
		,reader: new Ext.data.JsonReader({
			root : 'ddPositivoNegativo'
		} , DDPositivoNegativo)
	});
    
    
	///store storeDDCorrectoCobro
    var DDCorrectoCobro = Ext.data.Record.create([
                                                  	{id:'id'}
    	                                        	,{name:'codigo'}
													,{name:'descripcion'}
													 ]);


    this.storeDDCorrectoCobro= new Ext.data.Store({
	url:'/pfs/pcdprocesadoresoluciones/getDDCorrectoCobro.htm'
		,reader: new Ext.data.JsonReader({
			root : 'ddCorrectoCobro'
		} , DDCorrectoCobro)
	});
	   

    	
//    	this.dsPlazas.on('load', function(combo, r, options){    			
//        	debugger;
//        });
    	
    	refrescaComboPlaza = function(options){
    		var plazas=Ext.getCmp('d_plazaJuzgado' + options.params.idFactoria);
    		decenaInicio = 0;
    		if (plazas!='' && plazas!=null && options.params.dsProcedimiento.getAt(0)!=undefined) {
    			if ((plazas.getValue()!='' && plazas.getValue()!=null) || (options.params.dsProcedimiento.getAt(0).get('codigoPlaza')!='' && options.params.dsProcedimiento.getAt(0).get('codigoPlaza')!=null)){
    				if (plazas.getValue()!=''){
    					codigoPlaza = plazas.getValue();
    				}else if (options.params.dsProcedimiento.getAt(0).get('codigoPlaza')!=''){
    					codigoPlaza = options.params.dsProcedimiento.getAt(0).get('codigoPlaza');
    				}
        				Ext.Ajax.request({
        						url: '/pfs/plugin/procedimientos/paginaDePlaza.htm'
        						,params: {codigo: codigoPlaza}
        						,method: 'POST'
        						,success: function (result, request){
        							var r = Ext.util.JSON.decode(result.responseText)
        							decenaInicio = (r.paginaParaPlaza);
        							plazas.store.baseParams.start = decenaInicio;
        							plazas.store.baseParams.query = "";
        							plazas.store.load();
        							plazas.store.on('load', function(){  
        								plazas.setValue(codigoPlaza);
        								plazas.store.events['load'].clearListeners();
        							});
        						}				
        				});
        		}
    			//plazas.setValue(codigoPlaza);
    			var juzgado=Ext.getCmp('d_juzgado_id' + options.params.idFactoria);
        		if (juzgado!='' && juzgado!=null){
        			
        			storeJuzgado=juzgado.getStore();
        			storeJuzgado.purgeListeners();
        			storeJuzgado.load({params:{codigoPlaza:codigoPlaza, idFactoria:options.params.idFactoria}});
//        			storeJuzgado.load({params:{codigoPlaza:plazas.getValue(), idFactoria:this.idFactoria}});
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
    		}
    		
    		var numAutos2 =Ext.getCmp('d_numProcedimiento_id' + options.params.idFactoria);
    		if (numAutos2!='' && numAutos2!=null){
    			if (numAutos2.getValue()=='' || numAutos2.getValue()==null){
    				if (store.getAt(0).get('numeroAutos')!='' && store.getAt(0).get('numeroAutos')!=null){
    					numAutos2.setValue(store.getAt(0).get('numeroAutos'));
    					numAutos2.setReadOnly(true);
    					numAutos2.el.setStyle('background-image:none; background-color: #CCCCCC;');
    				}
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

    	this.storeMotivosSuspension.on('load', function(store, r, options){
    		var motivosSuspension=Ext.getCmp('d_motivoSuspension_id' + options.params.idFactoria);
    		if (motivosSuspension!='' && motivosSuspension!= null){
    			motivosSuspension.setValue(motivosSuspension.getValue());
    		}	
        });
    	
    	this.storeMotivosArchivo.on('load', function(store, r, options){
    		var motivosArchivo=Ext.getCmp('d_motivoArchivo_id' + options.params.idFactoria);
    		if (motivosArchivo!='' && motivosArchivo!= null){
    			motivosArchivo.setValue(motivosArchivo.getValue());
    		}	
        });
    	
    	
    	this.storeMotivosProrroga.on('load', function(store, r, options){
    		var motivosProrroga=Ext.getCmp('d_motivoProrroga_id' + options.params.idFactoria);
    		if (motivosProrroga!='' & motivosProrroga!=null){
    			motivosProrroga.setValue(motivosProrroga.getValue());
    		}
    	});
    	
    	this.storeDDFavorable.on('load', function(store, r, options){
    		var motivosFavorable=Ext.getCmp('d_comboResultado' + options.params.idFactoria);
    		if (motivosFavorable!='' & motivosFavorable!=null){
    			motivosFavorable.setValue(motivosFavorable.getValue());
    		}
    	});
    	
//    	this.storeDemandados.on('load', function(store, records, options){
//    		var nombreDemandado=Ext.getCmp('d_nombreDemandado_id' + options.params.idFactoria);
//    		var demandadoPrincipalProcedimiento =store.getAt(0).get('codigo');
//    		var demandadoProcedimiento= Ext.getCmp('demandadoProcedimiento_id'+ options.params.idFactoria);
//    		if (demandadoProcedimiento!='' && demandadoProcedimiento!=null){
//    			demandadoProcedimiento.setValue(demandadoPrincipalProcedimiento);
//    		}
//    		
//    		var storeBienes=null;
//    		if (nombreDemandado!='' && nombreDemandado!= null){
//    			var domicilios = Ext.getCmp('d_domicilioDemandado_id' + options.params.idFactoria);
//    			bienes = Ext.getCmp('d_bienesDemandado_id' + options.params.idFactoria);
//    			nombreDemandado.setValue(nombreDemandado.getValue());
//    			if (nombreDemandado.getValue()!= '' && nombreDemandado.getValue()!=null){
//	    			if (domicilios!='' && domicilios!=null){
//	    				var storeDomicilios=domicilios.getStore();
//	    				storeDomicilios.purgeListeners();
//	    				storeDomicilios.load({params:{idDemandado:nombreDemandado.getValue(), idFactoria:this.idFactoria}});
//	    				storeDomicilios.on('load', function(){
//	    					domicilios.setValue(domicilios.getValue());
//	    				});
//	    			}
//	    			if (bienes!='' && bienes!=null){
//	    				storeBienes=bienes.getStore();
//	    				storeBienes.purgeListeners();
//	    				storeBienes.load({params:{idDemandado:nombreDemandado.getValue(), idFactoria:this.idFactoria}});
//	    				storeBienes.on('load', function(){
//	    					bienes.setValue(bienes.getValue());
//	    				});
//	    			}
//    			}	
//    		}	
//        });

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

		/* Dani: Metemos 200 de relleno, esto habrá que quitarlo en Bankia y empezar por 1 */
		for(var i=1; i<201; i++){
			this.arrayCampos.push([]);
		}
		
    	 // id: 201 : TRAMITE HIPOTECARIO : Demanda Sellada
        this.arrayCampos.push([
         {"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
         ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
        	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
        		,listeners:{afterRender:function(combo){
        			 combo.mode='remote';
        		 		}
        		 }
          }
         ,{"xtype":'numberfield',"name":"d_valorTasacionSubasta","fieldLabel":"Valor de tasación para la subasta según escritura",allowBlank:false}
         ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
         ]);
        
        // id: 202 : TRAMITE HIPOTECARIO : Auto Despachando Ejecución Favorable
        this.arrayCampos.push([
         {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de Notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
         ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_nPlaza","hiddenName":"d_nPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
        	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
        		,listeners:{afterRender:function(combo){
        			 combo.mode='remote';
        		 		},
        		 		select :function(combo){
							var idFactoria = combo.id.replace('d_plazaJuzgado','');
							var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
							var storeJuzgado= juzgado.getStore();
							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
						}
        		 }
          }
         ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
         ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:function(idTipoResolucion){idTipoResolucion==1 || idTipoResolucion==92 || idTipoResolucion==135},
				id:'d_numProcedimiento_id'+this.idFactoria
				,validator : function(v) {
						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
				}
         }
        ,{"xtype":'combo',"store":storeSINO,"value":"01", "name":"d_comboResultado","fieldLabel":"Admisión","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo',allowBlank:false
        }         
        ]);
        
        // id: 203 : TRAMITE HIPOTECARIO : Auto Despachando Ejecución Desfavorable
        this.arrayCampos.push([
                               {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de Notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                               ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_nPlaza","hiddenName":"d_nPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
                              	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
                              		,listeners:{afterRender:function(combo){
                              			 combo.mode='remote';
                              		 		},
                              		 		select :function(combo){
                      							var idFactoria = combo.id.replace('d_plazaJuzgado','');
                      							var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
                      							var storeJuzgado= juzgado.getStore();
                      							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
                      						}
                              		 }
                                }
                               ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
                               ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:function(idTipoResolucion){idTipoResolucion==1 || idTipoResolucion==92 || idTipoResolucion==135},
                      				id:'d_numProcedimiento_id'+this.idFactoria
                      				,validator : function(v) {
                      						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
                      				}
                               }
                              ,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboResultado","fieldLabel":"Admisión","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
                              }         
                              ]);  

	// id: 204 : TRAMITE HIPOTECARIO : Confirmar notificacion del auto favorable
		this.arrayCampos.push([
		    {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima },
			{"xtype":'combo',"store":storeSINO,"value":"01", "name":"d_comboResultado","fieldLabel":"Confirmar Notificacion","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}		     
		
		]);

	// id: 205 : TRAMITE HIPOTECARIO : Confirmar notificacion del auto desfavorable
		this.arrayCampos.push([
			{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima },
			{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboResultado","fieldLabel":"Confirmar Notificacion","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}			
		
		]);
    
        
        // id: 206 : TRAMITE HIPOTECARIO : Requerimiento de Pago Positivo.
		this.arrayCampos.push([
			{"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha oposición",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'datefield',"name":"d_fechaComparecencia","fieldLabel":"Fecha comparecencia",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'combo',"store":storeSINO,"value":"01", "name":"d_comboResultado","fieldLabel":"Oposición","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
            }
		
		]);
        
        // id: 207 : TRAMITE HIPOTECARIO : Requerimiento de Pago Negativo.
		this.arrayCampos.push([
			{"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha oposición",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'datefield',"name":"d_fechaComparecencia","fieldLabel":"Fecha comparecencia",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboResultado","fieldLabel":"Oposición","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
            }
		
		]);
        
        // id: 208 : TRAMITE HIPOTECARIO : Escrito de oposición del contrario.
		this.arrayCampos.push([
		   			{"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		   			,{"xtype":'datefield',"name":"d_fechaComparecencia","fieldLabel":"Fecha comparecencia",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		   			,{"xtype":'combo',"store":storeSINO,"value":"01", "name":"d_comboResultado","fieldLabel":"Oposición","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
                    }
		   		
		   		]);
		
		
        // id: 209 : TRAMITE HIPOTECARIO : Senyalamiento Vista Oposición.
		this.arrayCampos.push([
		   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		   		]);
		

        // id: 210 : TRAMITE HIPOTECARIO : Auto Estimando Opsición.
		this.arrayCampos.push([
			   			{"xtype":'combo',"store":storeSINO,"value":"01", "name":"d_comboResultado","fieldLabel":"Oposición","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
			                                 }
			   			,{"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha Resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }			   		
			   		]);
		
		
        // id: 211 : TRAMITE HIPOTECARIO : Auto Desestimando Opsición.     
		this.arrayCampos.push([
					   			{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboResultado","fieldLabel":"Oposición","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
					                                 }
					   			,{"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha Resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }			   		
					   		]);



	// id: 212 : TRAMITE SUBASTA : Escrito sellado solicitando respuesta. 
		this.arrayCampos.push([
					   			{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboSolicitud","fieldLabel":"Solicitud de subasta por terceros","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboSolicitud'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
					                                 }
					   			,{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha Solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }			   		
					   		]);


	// id: 213 : TRAMITE SUBASTA : Edicto de subasta + D.O. Señalamiento subasta
	this.arrayCampos.push([
		{"xtype":'numberfield',"name":"d_principal","fieldLabel":"Principal",allowBlank:false}
		,{"xtype":'numberfield',"name":"d_intereses","fieldLabel":"Intereses generados a fecha del señalamiento de subasta.",allowBlank:false}
		,{"xtype":'numberfield',"name":"d_costasLetrado","fieldLabel":"Costas de letrado",allowBlank:false}
		,{"xtype":'datefield',"name":"d_fechaAnuncio","fieldLabel":"Fecha anuncio",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		,{"xtype":'numberfield',"name":"d_costasProcurador","fieldLabel":"Costas del procurador",allowBlank:false}
		,{"xtype":'datefield',"name":"d_fechaSenyalamiento","fieldLabel":"Fecha del señalamiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		

	]);

	// id: 214 : TRAMITE SUBASTA : Edicto de subasta + D.O. Señalamiento subasta
	this.arrayCampos.push([
		{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboCelebrada","fieldLabel":"Subasta celebrada","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCelebrada'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboCesion","fieldLabel":"Cesión de remate","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCesion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		,{"xtype":'combo',"store":this.storeMotivosSuspension, "name":"d_comboMotivo","fieldLabel":"Motivo de suspensión","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboMotivo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		,{"xtype":'combo',"store":this.storeDecisionSuspension, "name":"d_comboSuspension","fieldLabel":"Decisión de suspensión","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSuspension'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboComite","fieldLabel":"Postores en la subasta","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboComite'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
			]);

	
	// id: 215 : TRAMITE SUBASTA : D.O Entrega de cantidad consignada por 3º
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);

	// id: 216 : CESION DE REMATE : Resolución acordando fecha de cesión
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);
		
	// id: 217 : ADJUDICACIÓN : Escrito sellado solicitando adjudicación
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);

	// id: 218 : ADJUDICACIÓN : Decereto de adjudicación
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fecha","field":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboSubsanacion","fieldLabel":"Requiere subsanación","autoload":true, mode:'local',triggerAction:'all',resizable:true, 	id:'d_comboSubsanacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		,{"xtype":'combo',"store":this.storeEntidadAdjudicataria, "name":"d_comboEntidadAdjudicataria","fieldLabel":"Entidad Adjudicataria","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboEntidadAdjudicataria'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		,{"xtype":'combo',"store":this.storeFondo, "name":"d_fondo","fieldLabel":"Fondo","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_fondo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	]);
	
	// id: 219 : ADJUDICACIÓN : Decereto de adjudicación
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);

	// id: 220 : ADJUDICACIÓN : Decereto de adjudicación
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fechaTestimonio","fieldLabel":"Fecha testimonio",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboSubsanacion","fieldLabel":"Requiere subsanación","autoload":true, mode:'local',triggerAction:'all',resizable:true, 	id:'d_comboSubsanacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		,{"xtype":'datefield',"name":"d_fechaEnvioGestoria","fieldLabel":"Fecha envio gestoría",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);
	
	
    // id: 221 : TRAMITE COSTAS : Solicitud de tasación de costas
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
    // id: 222 : TRAMITE COSTAS : Tasación de costas del juzgado
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				,{"xtype":'numberfield',"name":"d_cuantia","fieldLabel":"Cuantía",allowBlank:false}]);
	
     //id: 223 : TRAMITE COSTAS : Impugnación tasación de costas del juzgado
	this.arrayCampos.push([
	                 {"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboImpugnacion","fieldLabel":"Impugnación","autoload":true, mode:'local',triggerAction:'all',resizable:true, 	id:'d_comboImpugnacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				,{"xtype":'datefield',"name":"d_fechaImpugnacion","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				,{"xtype":'datefield',"name":"d_vistaImpugnacion","fieldLabel":"Fecha vista",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				,{"xtype":'combo',"store":this.storeMotivoImpugnacion,"name":"d_comboResultado","fieldLabel":"Motivo impugnación","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	   				
    //id: 224 : TRAMITE COSTAS : Registrar celebración visita
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				]);
	
    //id: 225 : TRAMITE COSTAS : Registrar resolución
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_resultado","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_resultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 226 : TRAMITE COSTAS : Autoaprobacion de costas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Aprobadas","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 227 : TRAMITE CERTIFICACION CARGAS: Solicitud de certificacion de dominio y cargas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				]);
	
    //id: 228 : TRAMITE CERTIFICACION CARGAS: Registrar certificación
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Obtenida",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 229 : TRAMITE CERTIFICACION CARGAS: Solicitar información cargas anteriores
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Solicitada",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 230 : TRAMITE CERTIFICACION CARGAS: Registrar recepción información de cargas extinguidas o minoradas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeCompletitud,"name":"d_comboCompletitud","fieldLabel":"Información cargas",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCompletitud'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 231 : TRAMITE CERTIFICACION CARGAS: Requerir más información
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				]);
	
    //id: 232 : TRAMITE DE INTERESES: Solicitar liquidación de intereses
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaRec","fieldLabel":"Fecha de recepción",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaPre","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				]);
	
    //id: 233 : TRAMITE DE INTERESES: Registrar resolucion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_importe","fieldLabel":"Intereses",allowBlank:true}
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 234 : TRAMITE DE INTERESES: Registrar impugnacion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha impugnación",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Hay visita",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboImpugnacion","fieldLabel":"Hay impuganción",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboImpugnacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 235 : TRAMITE DE INTERESES: Trámite de notificación
	this.arrayCampos.push([]);
	
    //id: 236 : TRAMITE DE INTERESES: Registrar Vista
	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha vista",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }]);
	
	//id: 237 : TRAMITE DE INTERESES: Registrar Resolucion Vista
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 238 : TRAMITE GESTION DE LLAVES: Registrar Cambio de cerradura
	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha cambio cerradura",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }]);
	
	//id: 239 : TRAMITE GESTION DE LLAVES: Registrar Envio de Llaves
	this.arrayCampos.push([
	                       {"xtype":'textfield',"name":"d_nombre","fieldLabel":"Nombre del 1er depositario",allowBlank:false,id:'d_nombre_id'+this.idFactoria}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha envio de llaves letrado",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 240 : TRAMITE OCUPANTES: Solicitud de requerimiento documentación a ocupantes
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 241 : TRAMITE OCUPANTES: Registrar recepción de la documentación A
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaFinAle","fieldLabel":"Fecha fin alegaciones",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 242 : TRAMITE OCUPANTES: Registrar recepción de la documentación B
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaFinAle","fieldLabel":"Fecha fin alegaciones",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 243 : TRAMITE OCUPANTES: Registrar recepción de la documentación C
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaFinAle","fieldLabel":"Fecha fin alegaciones",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 244 : TRAMITE OCUPANTES: Presentar escrito alegaciones
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha presentación",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 245 : TRAMITE OCUPANTES: Confirmar visita
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboVista","fieldLabel":"Vista",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboVista'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);

	//id: 246 : TRAMITE OCUPANTES: Registrar resolución
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"fecha resolución",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 247 : TRAMITE MORATORIA DE LANZAMIENTO: Registrar solicitud de moratoria
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaFinMoratoria","fieldLabel":"Fecha de fin de moratoria",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha de solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 248 : TRAMITE MORATORIA DE LANZAMIENTO: Registrar admisión y emplazamiento
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboAdminEmplaza","fieldLabel":"Admisión y emplazamiento",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdminEmplaza'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboVista","fieldLabel":"Vista",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboVista'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaNotificacion","fieldLabel":"Fecha de notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaSenyalamiento","fieldLabel":"Fecha de señalamiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 249 : TRAMITE MORATORIA DE LANZAMIENTO: Presentar conformidad a moratoria
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 250 : TRAMITE MORATORIA DE LANZAMIENTO: Registrar resolución
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaFinMoratoria","fieldLabel":"Fecha fin de moratoria",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboFavDesf","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFavDesf'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 251 : TRAMITE DE POSESIÓN: Registrar solicitud de posesión
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO,"name":"d_comboPosesion","fieldLabel":"Combo de posesión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboPosesion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha de solicitud de la posesión",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Ocupado",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboMoratoria","fieldLabel":"Moratoria",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboMoratoria'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboViviendaHab","fieldLabel":"Vivienda Habitual",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboViviendaHab'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 252 : TRAMITE DE POSESIÓN: Registrar señalamiento posesión
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSenyalamiento","fieldLabel":"Fecha señalamiento para posesión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 253 : TRAMITE DE POSESIÓN: Registrar posesión y decisión lanzamiento
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Ocupado en la realización de la Diligencia",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha realización de la posesión",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboFuerzaPublica","fieldLabel":"Necesario fuerza pública",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFuerzaPublica'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboLanzamiento","fieldLabel":"Lanzamiento Necesario",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboLanzamiento'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaSolLanza","fieldLabel":"Fecha solicitud del lanzamiento",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 254 : TRAMITE DE POSESIÓN: Registrar señalamiento lanzamiento
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha señalamiento para el lanzamiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 255 : TRAMITE DE POSESIÓN: Registrar lanzamiento efectuado
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha lanzamiento efectivo",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboFuerzaPublica","fieldLabel":"Necesario fuerza pública",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFuerzaPublica'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 256 : PROCEDIMIENTO ORDINARIO: Interposicion de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.dsPlazas,allowBlank:true, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		}
		                      		 }
		                        }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                      ]);
	
	//id: 257 : PROCEDIMIENTO ORDINARIO: Confirmar admision de demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha admisión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.dsPlazas,allowBlank:true, "name":"d_nPlaza","hiddenName":"d_nPlaza",fieldLabel:"Plaza",triggerAction: 'all',resizable:true, id:'d_nPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                    		 		select :function(combo){
		            							var idFactoria = combo.id.replace('d_nPlaza','');
		            							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
		            							var storeJuzgado= juzgado.getStore();
		            							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		            						}
		                      		 }
		                        }
	                       ,{"xtype":'combo',"store":this.dsJuzgado,"name":"d_numJuzgado","fieldLabel":"Plaza",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_numJuzgado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 258 : PROCEDIMIENTO ORDINARIO: Confirmar notificacion de demanda
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado notificación",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 259 : PROCEDIMIENTO ORDINARIO: Confirmar si existe oposición
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaAudiencia","fieldLabel":"Fecha audiencia prévia",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 260 : PROCEDIMIENTO ORDINARIO: Registrar audiencia previa
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Visto para sentencia",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaJuicio","fieldLabel":"Fecha Juicio",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 261 : PROCEDIMIENTO ORDINARIO: Confirmar celebración de juicio
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 262 : PROCEDIMIENTO ORDINARIO: Registrar resolucion favorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"01","name":"d_comboResultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 263 : PROCEDIMIENTO ORDINARIO: Registrar resolucion desfavorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"02","name":"d_comboResultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 264 : PROCEDIMIENTO ORDINARIO: Resolución firme
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 265 : PROCEDIMIENTO MONITORIO: Interposición de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		}
	                      		 }
	                        }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                      ]);
	
	//id: 266 : PROCEDIMIENTO MONITORIO: Confirmar admisión de demanda
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":this.dsPlazas,allowBlank:true, "name":"d_nPlaza","hiddenName":"d_nPlaza",fieldLabel:"Plaza",triggerAction: 'all',resizable:true, id:'d_nPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                    		 		select :function(combo){
		            							var idFactoria = combo.id.replace('d_nPlaza','');
		            							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
		            							var storeJuzgado= juzgado.getStore();
		            							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		            						}
		                      		 }
		                        }
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
//	                       ,{"xtype":'combo',"store":this.dsJuzgado,"name":"d_numJuzgado","fieldLabel":"Juzgado designado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_numJuzgado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Juzgado designado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:function(idTipoResolucion){idTipoResolucion==1 || idTipoResolucion==92 || idTipoResolucion==135},id:'d_numProcedimiento_id'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                       	}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	
	//id: 267 : PROCEDIMIENTO MONITORIO: Confirmar notificación requerimiento de pago
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.dsPlazas,"name":"d_plazaJuzgado","fieldLabel":"Plaza del juzgado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 268 : PROCEDIMIENTO MONITORIO: Confirmar oposicion y cuantía
	this.arrayCampos.push([
							{"xtype":'textfield',"name":"d_procedimiento","fieldLabel":"Nº de procedimiento",allowBlank:true,id:'d_procedimiento'+this.idFactoria
									,validator : function(v) {
											return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
									}
							}
							,{"xtype":'textfield',"name":"d_deuda","fieldLabel":"Principal",allowBlank:true,id:'d_deuda'+this.idFactoria}
							,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
							,{"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha Oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
							,{"xtype":'datefield',"name":"d_fechaJuicio","fieldLabel":"Fecha Juicio",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 269 : PROCEDIMIENTO MONITORIO: Registrar auto despachando ejecución
	this.arrayCampos.push([
							{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de auto",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 270 : PROCEDIMIENTO VERBAL: INTERPOSICION DE LA DEMANDA
	this.arrayCampos.push([
							{"xtype":'datefield',"name":"d_fechainterposicion","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		}
		                      		 }
		                        }
							,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                      ]);
	
	//id: 271 : PROCEDIMIENTO VERBAL: CONFIRMAR ADMISIÓN DE DEMANDA
	this.arrayCampos.push([
							{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha admisión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		                    ,{"xtype":'combo',"store":this.dsPlazas,allowBlank:true, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                    		 		select :function(combo){
		            							var idFactoria = combo.id.replace('d_comboPlaza','');
		            							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
		            							var storeJuzgado= juzgado.getStore();
		            							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		            						}
		                      		 }
		                        }
							,{"xtype":'combo',"store":this.dsJuzgado,"name":"d_numJuzgado","fieldLabel":"Nº Juzgado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_numJuzgado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
							,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento'+this.idFactoria
								,validator : function(v) {
										return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
								}
							}
							,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmisionDemanda","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmisionDemanda'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 272 : PROCEDIMIENTO VERBAL: CONFIRMAR NOTIFICACIÓN DE DEMANDA
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha notificación",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'datefield',"name":"d_fechaJuicio","fieldLabel":"Fecha juicio",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 273 : PROCEDIMIENTO VERBAL: REGISTRAR JUICIO
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha celebración",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 274 : PROCEDIMIENTO VERBAL: REGISTRAR RESOLUCION DESFAVORABLE
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"value":"02","name":"d_comboResultado","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 275 : PROCEDIMIENTO VERBAL: REGISTRAR RESOLUCION FAVORABLE
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"value":"01","name":"d_comboResultado","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 276 : PROCEDIMIENTO VERBAL: RESOLUCIÓN FIRME
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 277 : PROCEDIMIENTO VERBAL DESDE MONITORIO: REGISTRAR JUICIO VERBAL
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha celebración",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                       	}
	                      ]);
	
	//id: 278 : PROCEDIMIENTO VERBAL DESDE MONITORIO: REGISTRAR RESOLUCIÓN DESFAVORABLE
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 279 : PROCEDIMIENTO VERBAL DESDE MONITORIO: REGISTRAR RESOLUCIÓN FAVORABLE
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 280 : PROCEDIMIENTO VERBAL DESDE MONITORIO: RESOLUCIÓN FIRME
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 281 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Solicitar certificación de dominio y cargas
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 282 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Registrar certificación
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Obtenida",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 283 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Solicitar información cargas anteriores
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Solicitada",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 284 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Registrar recepción información cargas extinguidas o minoradas
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeCompletitud,"name":"d_comboCompletitud","fieldLabel":"Información cargas",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCompletitud'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 285 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Requerir información que falta
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 286 : T. EMBARGO DE SALARIOS: Solicitar la notificacion retención al pagador
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'numberfield',"name":"d_importeNom","fieldLabel":"Importe base retención",allowBlank:true}
	                       	,{"xtype":'numberfield',"name":"d_importeRet","fieldLabel":"Importe de retención",allowBlank:false}
	                      ]);
	
	//id: 287 : T. EMBARGO DE SALARIOS: Confirmar requerimiento de resultado
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":storeSINO,"name":"d_comboRequerido","fieldLabel":"Requerido",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboRequerido'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'numberfield',"name":"d_importeNom","fieldLabel":"Importe base retención",allowBlank:true}
	                       	,{"xtype":'numberfield',"name":"d_importeRet","fieldLabel":"Importe de retención",allowBlank:true}
	                      ]);
	
	//id: 288 : T. EMBARGO DE SALARIOS: Confirmar retenciones
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDCorrectoCobro,"name":"d_comboCorr","fieldLabel":"Situación",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCorr'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 289 : T. EMBARGO DE SALARIOS: Confirmar retenciones
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 290 : T. VALORACIÓN INMUEBLE: Solicitar avaluo
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 291 : T. VALORACIÓN INMUEBLE: Obtencion avaluo
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 292 : T. VALORACIÓN INMUEBLE: Presentar alegaciones
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 293 : T. VALORACIÓN INMUEBLE: Presentar alegaciones
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_combo","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_combo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 294 : T. VALORACIÓN MUEBLE: solicitar justiprecio
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 295 : T. VALORACIÓN MUEBLE: registrar justiprecio
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaRegistro","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'numberfield',"name":"d_cuantia","fieldLabel":"Cuantía",allowBlank:false}
	                      ]);
	
	//id: 296 : T. MEJORA EMBARGO: solicitud mejora embargo
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 297 : T. MEJORA EMBARGO: Registro decreto de embargo
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaRegistro","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 298 : P. DE DEPOSITO: Solicitar nombramiento de depositario
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 299 : P. DE DEPOSITO: Nombramiento de depositario
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 300 : P. DE DEPOSITO: Aceptacion cargo depositario
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 301 : P. DE DEPOSITO: solicitar remocion depósito
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 302 : P. DE DEPOSITO: Acuerdo entrega depositario
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 303 : P. DE PRECINTO: Solicitud de precinto
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 304 : P. DE PRECINTO: Acuerdo de precinto
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 305 : T. INVESTIGACIÓN JUDICIAL: Solicitud de investigación judicial
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 306 : T. INVESTIGACIÓN JUDICIAL: Registrar resultado de investigación
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboSegSocial","fieldLabel":"Seg. social",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSegSocial'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboOtros","fieldLabel":"Otros",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOtros'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'numberfield',"name":"d_solvencia","fieldLabel":"Solvencia encontrada",allowBlank:true}
	                       	,{"xtype":'numberfield',"name":"d_impuestos","fieldLabel":"Ingresos encontrados",allowBlank:true}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboRegistro","fieldLabel":"Resultados",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboRegistro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAgTribut","fieldLabel":"Agencia tributaria",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAgTribut'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboCatastro","fieldLabel":"Catastro",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCatastro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAyto","fieldLabel":"Ayuntamiento",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAyto'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 307 : T. INVESTIGACIÓN JUDICIAL: Revisar resultado de investigación y actualizacion de datos
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboRegistro","fieldLabel":"Resultados",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboRegistro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAgTribut","fieldLabel":"Agesncia tributaria",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAgTribut'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboSegSocial","fieldLabel":"Seg. social",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSegSocial'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboCatastro","fieldLabel":"Catastro",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCatastro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAyto","fieldLabel":"Ayuntamiento",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAyto'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboOtros","fieldLabel":"Otros",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOtros'+this.idFactoria,displayField:'descripcion',valueField:'codigo'},{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAyto","fieldLabel":"Ayuntamiento",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAyto'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'numberfield',"name":"d_solvencia","fieldLabel":"Solvencia encontrada",allowBlank:true}
	                       	,{"xtype":'numberfield',"name":"d_impuestos","fieldLabel":"Ingresos encontrados",allowBlank:true}
	                      ]);
	
	//id: 308 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Interposicion de la demanda - marcado de bienes
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaInterposicion","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                        ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_nPlaza","hiddenName":"d_nPlaza",fieldLabel:"Plaza",triggerAction: 'all',resizable:true, id:'d_nPlaza'+this.idFactoria
	                       	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                       		,listeners:{afterRender:function(combo){
	                       			 combo.mode='remote';
	                       		 		}
	                       		 }
	                         }
	                        ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                      ]);
	
	
	//id: 309 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Auto despachando ejecucion - marcado de bienes decreto embargo
	this.arrayCampos.push([
	                       {"xtype":'combo',"store": this.dsPlazas, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		},
	                      		 		select :function(combo){
	              							var idFactoria = combo.id.replace('d_comboPlaza','');
	              							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
	              							var storeJuzgado= juzgado.getStore();
	              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
	              						}
	                      		 }
	                        }
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_numJuzgado' + this.idFactoria }
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento_id'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                        }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmisionDemanda","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmisionDemanda'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 310 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Auto despachando ejecucion - marcado de bienes decreto embargo (clausulas abusivas)
	this.arrayCampos.push([
	                       {"xtype":'combo',"store": this.dsPlazas, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		},
	                      		 		select :function(combo){
	              							var idFactoria = combo.id.replace('d_comboPlaza','');
	              							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
	              							var storeJuzgado= juzgado.getStore();
	              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
	              						}
	                      		 }
	                        }
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_numJuzgado' + this.idFactoria }
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento_id'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                        }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmisionDemanda","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmisionDemanda'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 311 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Auto despachando ejecucion - marcado de bienes decreto embargo (clausulas abusivas)
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_repetir","fieldLabel":"Activar alerta periódica",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_repetir'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 312 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Confirmar notificacion requerimiento de pago
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboConfirmacionReqPago","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboConfirmacionReqPago'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 313 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Confirmar si existe oposición
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboConfirmacion","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboConfirmacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 314 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Confirmar si existe oposición
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 315 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Registrar celebración vista
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 316 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Registrar resolucion desfavorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_combo","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_combo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 317 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Registrar resolucion favorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_combo","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_combo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 318 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Resolución firme
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 319 : T. EJECUCIÓN TÍTULO JUDICIAL: Interposición de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		},
	                      		 		select :function(combo){
	              							var idFactoria = combo.id.replace('d_plazaJuzgado','');
	              							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
	              							var storeJuzgado= juzgado.getStore();
	              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
	              						}
	                      		 }
	                        }
	                       ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_numJuzgado' + this.idFactoria }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                      ]);
	
	//id: 320 : T. EJECUCIÓN TÍTULO JUDICIAL: Auto despachando ejecucion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_nProc","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_nProc'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                        }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 321 : T. EJECUCIÓN TÍTULO JUDICIAL: Auto despachando ejecucion clausulas abusivas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_nProc","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_nProc'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                        }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 322 : T. EJECUCIÓN TÍTULO JUDICIAL: Confirmar anotacion en registro
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_repetir","fieldLabel":"Activar alerta periódica",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_repetir'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 323 : T. EJECUCIÓN TÍTULO JUDICIAL: Confirmar notificacion
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboSiNo","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);   
	
	//id: 324 : T. EJECUCIÓN TÍTULO JUDICIAL: Registrar oposicion visita
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 325 : T. EJECUCIÓN TÍTULO JUDICIAL: Confirmar presentar impugnacion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 326 : T. EJECUCIÓN TÍTULO JUDICIAL: Hay Vista
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Hay vista",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 327 : T. EJECUCIÓN TÍTULO JUDICIAL: Registrar Vista
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 328 : T. EJECUCIÓN TÍTULO JUDICIAL: Registrar resolución desfavorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"02","name":"d_resultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_resultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 329 : T. EJECUCIÓN TÍTULO JUDICIAL: Registrar Favorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"01","name":"d_resultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_resultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 330 : T. EJECUCIÓN TÍTULO JUDICIAL: Resolución firme
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 331 : P. CAMBIARIO: Interposicion de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaDemanda","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',allowBlank:false, resizable:true, id:'d_plazaJuzgado'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		}
		                      		 }
		                     }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                      ]);
	
	//id: 332 : P. CAMBIARIO: Confirmar admision de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                      		 		select :function(combo){
		              							var idFactoria = combo.id.replace('d_comboPlaza','');
		              							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
		              							var storeJuzgado= juzgado.getStore();
		              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		              						}
		                      		 }
		                        }
		                     ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:'300',mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_numJuzgado' + this.idFactoria }
		                     ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false, id:'d_numProcedimiento_id'+this.idFactoria
		         				,validator : function(v) {
		         						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		         				}
		                      }
		                     ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmisionDemanda","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmisionDemanda'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 333 : P. CAMBIARIO: Registrar anotación en registro
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_repetir","fieldLabel":"Activar alerta periódica",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_repetir'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 334 : P. CAMBIARIO: Confirmar notificación requerimiento de pago
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboConfirmar","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboConfirmar'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 335 : P. CAMBIARIO: Registrar demanda oposición
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO,"name":"d_comboRegistro","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboRegistro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 336 : P. CAMBIARIO: Registrar auto despachando ejecucion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 337 : P. CAMBIARIO: Registrar juicio y comparecencia
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 338 : P. CAMBIARIO: Registrar resolución desfavorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"02","name":"d_combo","fieldLabel":"Resultado",readOnly: true, allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_combo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 339 : P. CAMBIARIO: Registrar resolución favorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"01","name":"d_combo","fieldLabel":"Resultado",readOnly: true, allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_combo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 340 : P. CAMBIARIO: Resolución firme
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 341 : T. MEJORA EMBARGO: Registrar anotación en registro
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaRegistro","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":storeSINO,"name":"d_repetir","fieldLabel":"Hay bienes, con embargo registrado, no adjudicados",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_repetir'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
		for(var i=342; i<1000; i++){
			this.arrayCampos.push([]);
		}
		
		///ESPECIALES
		
		// id: 1000 : Subida de ficheros
        this.arrayCampos.push([
        ]);
        
        // id: 1001 : Autoprórroga
        this.arrayCampos.push([
                {"xtype":'datefield',"name":"d_fechaProrroga","fieldLabel":"Fecha Prórroga",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                ,{"xtype":'combo',"editable":"false","store":this.storeMotivosProrroga, width:'250', mode:'local', "name":"d_motivoProrroga","hiddenName":"d_motivoProrroga", id:'d_motivoProrroga_id' + this.idFactoria,"fieldLabel":"Motivo Pr&oacute;rroga",triggerAction: 'all',allowBlank:true,displayField:'descripcion',valueField:'codigo', "autoload":true }
        ]);

        // id: 1002 : Comunicación
        this.arrayCampos.push([
		        {"xtype":'combo',"store": ["Si", "No"], "name":"d_requiererespuesta","fieldLabel":"Requiere respuesta","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_requiererespuesta'+this.idFactoria}
                ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                ,{"xtype":'textarea',"name":"d_texto","fieldLabel":"Texto",allowBlank:false,width:300}
        ]);
        
        // id : 1003 : Tarea
        this.arrayCampos.push([
			{"xtype":'textfield',"name":"d_asunto","fieldLabel":"Asunto",allowBlank:false}
			,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de vencimiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'textarea',"name":"d_mensaje","fieldLabel":"Mensaje",allowBlank:false,width:300}
        ]);
        
        // id : 1004 : Autotarea
        this.arrayCampos.push([
			{"xtype":'textfield',"name":"d_asunto","fieldLabel":"Asunto",allowBlank:false}
			,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de vencimiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'textarea',"name":"d_mensaje","fieldLabel":"Mensaje",allowBlank:false,width:300}
        ]);
        
        // id : 1005 : Notificación
        this.arrayCampos.push([
			{"xtype":'textfield',"name":"d_asunto","fieldLabel":"Asunto",allowBlank:false}
			,{"xtype":'textarea',"name":"d_mensaje","fieldLabel":"Mensaje",allowBlank:false,width:300}
        ]);
   
    }
	

});
