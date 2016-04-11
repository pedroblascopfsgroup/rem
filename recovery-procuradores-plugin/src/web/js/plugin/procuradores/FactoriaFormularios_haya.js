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

function OnLoadCampo(campo){

	var cmp =Ext.getCmp(campo.id);
    var cmp_selected = cmp.getValue();

    campo.store.on('load', function(){  
            cmp.setValue(cmp_selected);
            cmp.store.events['load'].clearListeners();
            cmp.store.baseParams.codigo = "";
        }); 
}

function arrayObjectIndexOf(myArray, searchTerm, property) {
    for(var i = 0, len = myArray.length; i < len; i++) {
        if (myArray[i][property] === searchTerm) return i;
    }
    return -1;
}

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
	//storeDemandados:{},
	//storeDomicilios:{},
	//storeBienes:{},
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
	storeDDIndebidaExcesiva:{},
    storeDDSituacionTitulo:{},
    storeDDTipoBienCajamar:{},
    storeDDPosesionInterinaResolucion:{},
    
    constructor : function(options){    //Step 2  
    	Date.now = Date.now || function() { return +new Date; };
    	Ext.apply(this,options || {idFactoria: Date.now(), arrayCampos: []});
        this.initArrays(this.idFactoria);
    },
    
/*
    updateStores: function(){
    	this.dsPlazas.load({params:{idFactoria:this.idFactoria, dsProcedimiento:this.dsProcedimiento}});    	
    	this.dsProcedimiento.load({params:{idFactoria:this.idFactoria, idProcedimiento:this.idProcedimiento}});
    	this.storeRequerimientos.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivosInadmision.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivosProrroga.load({params:{idFactoria:this.idFactoria}});
    	this.storeMotivosArchivo.load({params:{idFactoria:this.idFactoria}});
    	//this.storeDemandados.load({params:{idProcedimiento:this.idProcedimiento, idFactoria:this.idFactoria}});
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
*/    
    
    
    updateStores: function(idTipoResolucion){
    	
        campos = this.arrayCampos[idTipoResolucion];
        this.dsDatosAdicionales.load({params:{idProcedimiento:this.idProcedimiento}});
        for (var i=0;i<campos.length;i++)
        {        
                var campo=campos[i];
                
                if(typeof campo.store != 'undefined' && (campo.store instanceof Ext.data.Store) && (campo.store.getTotalCount( ) == 0 && campo.store.url!="/pfs/pcdprocesadoresoluciones/getJuzgadosByPlaza.htm") ){
                        
                        var cmp_selected = Ext.getCmp(campo.id).getValue();

                        if(cmp_selected != null && cmp_selected != ''){
                                ////CARGAMOS SOLO EL ELEMENTO SELECCIONADO
                                campo.store.baseParams.codigo = cmp_selected;
                                campo.store.baseParams.query = "";
                                campo.store.load();
                                OnLoadCampo(campo);        
                        }else{
                                campo.store.baseParams.codigo = "";
                                campo.store.baseParams.query = "";
                                campo.store.load({params:{idFactoria:this.idFactoria}});
                        }
                        
                }
                
        }
    },


    fullFields: function(idTipoResolucion, valoresCamposAnteriores){

        campos = this.arrayCampos[idTipoResolucion];

    	if(valoresCamposAnteriores){

    		for (var i=0;i<campos.length;i++){

//			SOLO AUTO RELLENAMOS LOS QUE SE MARQUEN CON EL ATRIBUTO SameValue LOS QUE COINCIDAN EL NOMBRE NO    			
//    			if(valoresCamposAnteriores[campos[i].name.replace("d_","")]){
//
//    				if(campos[i].id && !campos[i].hidden){
//        				var campo = Ext.getCmp(campos[i].id);
//        				campo.setValue(valoresCamposAnteriores[campos[i].name.replace("d_","")]);
//        				
//        				if(campo.xtype == 'combo'){
//        					campo.fireEvent('select', campo);
//        				}	
//    				}
//    			}
    			
    			if(campos[i].sameValue!=undefined && valoresCamposAnteriores[campos[i].sameValue.replace("d_","")]){

    				if(campos[i].id){
	    				var campo = Ext.getCmp(campos[i].id);
	    				campo.setValue(valoresCamposAnteriores[campos[i].sameValue.replace("d_","")]);
	    				
	    				if(campo.xtype == 'combo'){
	    					campo.fireEvent('select', campo);
	    				}
    				}
    			}
    		}
    	}
    },
    
    getFormItems: function(idTipoResolucion, idAsunto, codigoProcedimiento, codPlaza,idProcedimiento, filtrar, filtradoProcurador){
    	//debugger;
    	this.idAsunto=idAsunto;
    	this.codigoProcedimiento=codigoProcedimiento;
    	codigoPlaza=codPlaza;
    	this.idProcedimiento=idProcedimiento;
    	   	
    	var campos = null;
    	campos = this.arrayCampos[idTipoResolucion];
   	
    	if (filtrar){
    		for (var i=0;i<campos.length;i++){
    			if(campos[i].filtrar){
    				campos[i].hidden=true;
    				campos[i].allowBlank=true;
    			}
    		}
    	}
    	
    	if(filtradoProcurador){
    		for (var i=0;i<campos.length;i++){
    			if(campos[i].filtradoProcurador){
    				campos[i].allowBlank=true;
    				campos[i].esProcurador=true;
    			}
    		}
    	}
    	

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
    	
    	/* Obligatoriedad del adjunto */
    	var esResolEspecial = true;
    	if( idTipoResolucion <= 1000 ){esResolEspecial = false;}
    	
    	var resolucionesSinAdjunto = [];
    	//resolucionesSinAdjunto.push(242) /* H040_RegistrarCambioCerradura */
    	
    	var idf = this.idFactoria;
    	
    	/*AÑADIMOS LAS RESOLUCIONES QUE NO NECESITAN ADJUNTAR FICHERO, PERMITE AÑADIR UNA VALIDACION CONCRETA POR SI DEPENDE DE LOS VALORES DE LOS CAMPOS EL AÑADIR O NO*/
//    	resolucionesSinAdjunto.push({idResolucion:239, validateFunction:null});
    	resolucionesSinAdjunto.push({idResolucion:311, validateFunction:null});
    	resolucionesSinAdjunto.push({idResolucion:314, validateFunction:null});
    	resolucionesSinAdjunto.push({idResolucion:340, validateFunction:null});
        resolucionesSinAdjunto.push({idResolucion:328, validateFunction:null});
        resolucionesSinAdjunto.push({idResolucion:331, validateFunction:null});
        resolucionesSinAdjunto.push({idResolucion:268, validateFunction:null});
        resolucionesSinAdjunto.push({idResolucion:279, validateFunction:null});
        resolucionesSinAdjunto.push({idResolucion:282, validateFunction:null});
        resolucionesSinAdjunto.push({idResolucion:343, validateFunction:null});

        resolucionesSinAdjunto.push({idResolucion:325, validateFunction:function(v) {
            // Valida la resolucion cuando el combo confirmacion tenga un valor NO o bien se haya adjuntado un archivo
            return (Ext.getCmp('d_comboConfirmacion' + idf).getValue() == "02" || Ext.getCmp('file_upload_ok').getValue() != "");
        }});

        resolucionesSinAdjunto.push({idResolucion:275, validateFunction:function(v) {
            // Valida la resolucion cuando el combo resultado tenga un valor NO o bien se haya adjuntado un archivo
            return (Ext.getCmp('d_comboResultado' + idf).getValue() == "02" || Ext.getCmp('file_upload_ok').getValue() != "");
        }});

        resolucionesSinAdjunto.push({idResolucion:249, validateFunction:function(v) {
            // Valida la resolucion cuando el combo vista tenga un valor NO o bien se haya adjuntado un archivo
            return (Ext.getCmp('d_comboVista' + idf).getValue() == "02" || Ext.getCmp('file_upload_ok').getValue() != "");
        }});

        resolucionesSinAdjunto.push({idResolucion:206, validateFunction:function(v){
			if(Ext.getCmp('d_comboResultado' + idf).getValue() == "02"){
				return true;
			}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
					return true;
	    		}else{
	    			return false;
	    	}
    	}});
    	resolucionesSinAdjunto.push({idResolucion:327, validateFunction:function(v){
			if(Ext.getCmp('d_comboHayVista' + idf).getValue() == "02"){
				return true;
			}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
					return true;
		}}});
    	resolucionesSinAdjunto.push({idResolucion:229, validateFunction:function(v){
    		if(Ext.getCmp('d_comboImpugnacion' + idf).getValue() == "02"){
    			return true;
    		}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
    				return true;
    			}else{
    				return false;
    			}
    		}});
    	resolucionesSinAdjunto.push({idResolucion:309, validateFunction:function(v){
    		if(Ext.getCmp('d_comboOposicion' + idf).getValue() == "02"){
    			return true;
    		}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
    				return true;
    			}else{
    				return false;
    			}
    		}});
    	resolucionesSinAdjunto.push({idResolucion:337, validateFunction:function(v){
    		if(Ext.getCmp('d_comboSiNo' + idf).getValue() == "02"){
    			return true;
    		}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
    				return true;
    			}else{
    				return false;
    			}
    		}});
    	resolucionesSinAdjunto.push({idResolucion:339, validateFunction:function(v){
    		if(Ext.getCmp('d_comboSiNo' + idf).getValue() == "02"){
    			return true;
    		}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
    				return true;
    			}else{
    				return false;
    			}
    		}});
    	resolucionesSinAdjunto.push({idResolucion:289, validateFunction:function(v){
    		if(Ext.getCmp('d_comboResultado' + idf).getValue() == "02"){
    			return true;
    		}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
    				return true;
    			}else{
    				return false;
    			}
    		}});
    	
    	

//    	
//    	resolucionesSinAdjunto.push({idResolucion:253, validateFunction:function(v){
//    		
//    		if(Ext.getCmp('d_comboAdminEmplaza' + idf).getValue() == "02"){
//    			return true;
//    		}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
//    				return true;
//	    		}else{
//	    			return false;
//	    	}
//    	}});
//    	
//    	resolucionesSinAdjunto.push({idResolucion:337, validateFunction:function(v){
//    		
//    		if(Ext.getCmp('d_comboSiNo' + idf).getValue() == "02"){
//    			return true;
//    		}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
//    				return true;
//	    		}else{
//	    			return false;
//	    	}
//    	}});
//    	
//    	resolucionesSinAdjunto.push({idResolucion:339, validateFunction:function(v){
//    		
//    		if(Ext.getCmp('d_comboSiNo' + idf).getValue() == "02"){
//    			return true;
//    		}else if(Ext.getCmp('file_upload_ok').getValue() != ""){
//    				return true;
//	    		}else{
//	    			return false;
//	    	}
//    	}});
//    	
//    	resolucionesSinAdjunto.push({idResolucion:343, validateFunction:null});
    	
    	
    	
    	
    	var adjuntoNoObligatorio = false;
    	
    	var pos = arrayObjectIndexOf(resolucionesSinAdjunto, idTipoResolucion, "idResolucion");
    	
    	var valueFlUp = "";
    	
    	if(esResolEspecial || pos!=-1)
    	{
    		adjuntoNoObligatorio = true;
    		valueFlUp = "ok";
    	}
    	
    	var validatorFnc =  function(v){return true;} 
    	if(pos!=-1 && resolucionesSinAdjunto[pos].validateFunction != null){
    		valueFlUp = "";
    		validatorFnc = resolucionesSinAdjunto[pos].validateFunction;
    	}

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
				      	  	,{"xtype": 'textfield', "id": 'file_upload_ok',"name": 'file_upload_ok',"value": valueFlUp ,allowBlank:adjuntoNoObligatorio,hidden:true, validator:validatorFnc
				      	  	}
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
    	
    	
    	
    	this.dsPlazas = new Ext.data.Store({
    		autoLoad: false,
    		baseParams: {limit:10, start:0},
    		url:'/pfs/pcdprocesadoresoluciones/getPlazas.htm',
    		actionMethods: {
    			create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'
    			},
    		reader: new Ext.data.JsonReader({
    			root: 'diccionario'
    			,totalProperty: 'total'
    		}, [
    			{name: 'codigo', mapping: 'codigo'},
    			{name: 'descripcion', mapping: 'descripcion'}
    		])
    	});
    	
    	
    	//COMENTADO CARLOS PARA AÑADIR QUE BUSQUE POR CODIGO
//    	this.dsPlazas = new Ext.data.Store({
//    		autoLoad: false,
//    		baseParams: {limit:10, start:0},
//    		url:'/pfs/plugin/procedimientos/plazasDeJuzgados.htm',
//    		actionMethods: {
//    			create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'
//    			},
//    		reader: new Ext.data.JsonReader({
//    			root: 'plazas'
//    			,totalProperty: 'total'
//    		}, [
//    			{name: 'codigo', mapping: 'codigo'},
//    			{name: 'descripcion', mapping: 'descripcion'}
//    		])
//    	});
    	
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
    	                                                     ,{name : 'cuantiaLetrado'} 
    	                                                     ,{name : 'cuantiaProcurador'} 
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
    
    ////storeDDIndebidaExcesiva
    var DDIndebidaExcesiva = Ext.data.Record.create([
                                                	{id:'id'}
  	                                        	,{name:'codigo'}
													,{name:'descripcion'}
													,{name:'descripcionLarga'}
													 ]);


  this.storeDDIndebidaExcesiva= new Ext.data.Store({
	url:'/pfs/pcdprocesadoresoluciones/getIndebidaExcesiva.htm'
		,reader: new Ext.data.JsonReader({
			root : 'listaIndebidas'
		} , DDIndebidaExcesiva)
	});


    // DDSituacionTitulo - CAJAMAR
    var DDSituacionTitulo = Ext.data.Record.create([
        {id:'id'}
        ,{name:'codigo'}
        ,{name:'descripcion'}
    ]);

    this.storeDDSituacionTitulo = new Ext.data.Store({
        url:'/pfs/pcdprocesadoresoluciones/getDictionary.htm'
        ,baseParams: {
            dictionary: 'es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionTitulo'
        }
        ,reader: new Ext.data.JsonReader({
            root: 'diccionario'
        } , DDSituacionTitulo)
    });

    // DDTipoBienCajamar - CAJAMAR
    var DDTipoBienCajamar = Ext.data.Record.create([
        {id:'id'}
        ,{name:'codigo'}
        ,{name:'descripcion'}
    ]);

    this.storeDDTipoBienCajamar = new Ext.data.Store({
        url:'/pfs/pcdprocesadoresoluciones/getDictionaryDenormalized.htm'
        ,baseParams: {
            dictionary: 'es.pfsgroup.recovery.hrebcc.model.DDTipoBienCajamar'
        }
        ,reader: new Ext.data.JsonReader({
            root: 'diccionario'
        } , DDTipoBienCajamar)
    });

    // DDPosesionInterinaResolucion - CAJAMAR
    var DDPosesionInterinaResolucion = Ext.data.Record.create([
        {id:'id'}
        ,{name:'codigo'}
        ,{name:'descripcion'}
    ]);

    this.storeDDPosesionInterinaResolucion = new Ext.data.Store({
        url:'/pfs/pcdprocesadoresoluciones/getDictionary.htm'
        ,baseParams: {
            dictionary: 'es.pfsgroup.recovery.hrebcc.model.DDPosesionInterinaResolucion'
        }
        ,reader: new Ext.data.JsonReader({
            root: 'diccionario'
        } , DDPosesionInterinaResolucion)
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

    		var i=0;
			var conTestimonio = Ext.getCmp('d_contratoRecibido_id');
			if (conTestimonio != '' && conTestimonio != null && store.getAt(i).get('conTestimonio') != '' ) {
				var valor = "";
				if(store.getAt(0).get('conTestimonio') == "S"){
					valor = "SI"
				}else if(store.getAt(0).get('conTestimonio') == "N"){
					valor = "NO"
				}
				conTestimonio.setValue(valor);
				conTestimonio.setReadOnly(true);
				i++;
			}
			
			var cuantiaLetrado = Ext.getCmp('d_cuantiaLetrado_id');
			if (cuantiaLetrado != '' && cuantiaLetrado != null && store.getAt(i).get('cuantiaLetrado') != '' ) {
				
				cuantiaLetrado.setValue(store.getAt(i).get('cuantiaLetrado'));
				cuantiaLetrado.setReadOnly(false);
				i++;
			}
			
			var cuantiaProcurador = Ext.getCmp('d_cuantiaProcurador_id');
			if (cuantiaProcurador != '' && cuantiaProcurador != null && store.getAt(i).get('cuantiaProcurador') != '' ) {
				
				cuantiaProcurador.setValue(store.getAt(i).get('cuantiaProcurador'));
				cuantiaProcurador.setReadOnly(false);
				i++
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
         {"xtype":'datefield',"name":"d_fechaPresentacionDemanda","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
         ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
        	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
        		,listeners:{afterRender:function(combo){
        			 combo.mode='remote';
        		 		}
        		 }
          }
         ,{"xtype":'datefield',"name":"d_fechaCierreDeuda","fieldLabel":"Fecha cierre de la deuda",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, filtrar:true }
         ,{"xtype":'numberfield',"name":"d_principalDeLaDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
         ,{"xtype":'numberfield',"name":"d_capitalVencidoEnElCierre","fieldLabel":"Capital vencido (en el cierre)",allowBlank:false, filtrar:true}
         ,{"xtype":'numberfield',"name":"d_capitalNoVencidoEnElCierre","fieldLabel":"Capital no vencido (en el cierre)",allowBlank:false, filtrar:true}
         ,{"xtype":'numberfield',"name":"d_interesesOrdinariosEnElCierre","fieldLabel":"Intereses ordinarios (en el cierre)",allowBlank:false, filtrar:true}
         ,{"xtype":'numberfield',"name":"d_interesesDeDemoraEnElCierre","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:false, filtrar:true}
         ,{"xtype":'numberfield',"name":"d_plazoInteresesOrdinarios","fieldLabel":"Plazo intereses ordinarios",allowBlank:false, filtrar:true}         
         ,{"xtype":'numberfield',"name":"d_tipoMaximoInteresesOrdinarios","fieldLabel":"Tipo máximo intereses ordinarios",allowBlank:false, filtrar:true}
         ,{"xtype":'numberfield',"name":"d_plazoInteresesDemora","fieldLabel":"Plazo intereses demora",allowBlank:false, filtrar:true}
         ,{"xtype":'numberfield',"name":"d_tipoMaximoInteresesDemora","fieldLabel":"Tipo máximo intereses demora",allowBlank:false, filtrar:true}
         ,{"xtype":'numberfield',"name":"d_tipoInteresDemora","fieldLabel":"Tipo de interés de demora",allowBlank:false, filtrar:true}         
         ]);
        
        // id: 202 : TRAMITE HIPOTECARIO : Auto Despachando Ejecución Favorable
        this.arrayCampos.push([
         {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de Notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
         ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_nPlaza",allowBlank:false,"hiddenName":"d_nPlaza",sameValue:"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
        	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
        		,listeners:{afterRender:function(combo){
        			 combo.mode='remote';
        		 		},
        		 		select :function(combo){
							var idFactoria = combo.id.replace('d_plazaJuzgado','');
							var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
							var storeJuzgado= juzgado.getStore();
							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
							storeJuzgado.on('load', function(){  
								  var foundValue = false;
								  storeJuzgado.each(function(record)  
								  {
									  if(record.get("codigo") == juzgado.getValue()){
										  juzgado.setValue(juzgado.getValue());
										  foundValue = true;
									  }

								  }, this); 
								
								  if(!foundValue){
									  juzgado.setValue("");
								  }
							});
						}
        		 }
          }
         ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:280,mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
         ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:function(idTipoResolucion){idTipoResolucion==1 || idTipoResolucion==92 || idTipoResolucion==135},
				id:'d_numProcedimiento_id'+this.idFactoria
				,validator : function(v) {
						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
				}
         }
        ,{"xtype":'combo',"store":storeSINO,"value":"01", filtrar:true, "name":"d_comboResultado","fieldLabel":"Admisión","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo',allowBlank:false}         
        ]);
        
        // id: 203 : TRAMITE HIPOTECARIO : Auto Despachando Ejecución Desfavorable
        this.arrayCampos.push([
                               {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de Notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                               ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_nPlaza","hiddenName":"d_nPlaza",sameValue:"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
                              	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
                              		,listeners:{afterRender:function(combo){
                              			 combo.mode='remote';
                              		 		},
                              		 		select :function(combo){
                      							var idFactoria = combo.id.replace('d_plazaJuzgado','');
                      							var juzgado=Ext.getCmp('d_juzgado_id' + idFactoria);
                      							var storeJuzgado= juzgado.getStore();
                      							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
                    							storeJuzgado.on('load', function(){  

                    								  var foundValue = false;
                    								  storeJuzgado.each(function(record)  
                    								  {
                    									  if(record.get("codigo") == juzgado.getValue()){
                    										  juzgado.setValue(juzgado.getValue());
                    										  foundValue = true;
                    									  }

                    								  }, this); 
                    								
                    								  if(!foundValue){
                    									  juzgado.setValue("");
                    								  }
                    								  
                    							});
                      						}
                              		 }
                                }
                               ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:280,mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_juzgado_id' + this.idFactoria }
                               ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:function(idTipoResolucion){idTipoResolucion==1 || idTipoResolucion==92 || idTipoResolucion==135},
                      				id:'d_numProcedimiento_id'+this.idFactoria
                      				,validator : function(v) {
                      						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
                      				}
                               }
                              ,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboResultado","fieldLabel":"Admisión","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo',filtrar:true}         
                              ]);  
    
        
        // id: 204 : TRAMITE HIPOTECARIO : Requerimiento de Pago Positivo.
		this.arrayCampos.push([
			{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
//			,{"xtype":'datefield',"name":"d_fechaComparecencia","fieldLabel":"Fecha comparecencia",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"value":"01", "name":"d_comboResultado","fieldLabel":"Positivo / Negativo","autoload":true,filtrar:true,allowBlank:false,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
            }
		
		]);
        
        // id: 205 : TRAMITE HIPOTECARIO : Requerimiento de Pago Negativo.
		this.arrayCampos.push([
			{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
//			,{"xtype":'datefield',"name":"d_fechaComparecencia","fieldLabel":"Fecha comparecencia",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"value":"02", "name":"d_comboResultado","fieldLabel":"Positivo / Negativo", filtrar:true,allowBlank:false, "autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
            }
		
		]);
        
        // id: 206 : TRAMITE HIPOTECARIO : Escrito de oposición del contrario.
		this.arrayCampos.push([
		   			{"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaOposicion'+this.idFactoria
		   				,validator : function(v) {
	               	   		if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaOposicion' + idFactoria).getValue() == ""){
	               	   			return false;
	               	   		}else{
	               	   			return true;
	               	   		}
      					}
		   			}
		   			,{"xtype":'datefield',"name":"d_fechaComparecencia","fieldLabel":"Fecha comparecencia",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaComparecencia'+this.idFactoria
//		   				,validator : function(v) {
//	               	   		if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaComparecencia' + idFactoria).getValue() == ""){
//	               	   			return false;
//	               	   		}else{
//	               	   			return true;
//	               	   		}
//      					}
		   			}
		   			,{"xtype":'combo',"store":storeSINO,"value":"01", "name":"d_comboResultado","fieldLabel":"Oposición","autoload":true,allowBlank:false,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		   			,{"xtype":'textarea',"name":"d_motivoOposicion","fieldLabel":"Motivo oposición",allowBlank:true,filtrar:true,width:285, id:'d_motivoOposicion'+this.idFactoria
		   				,validator : function(v) {
	               	   		if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_motivoOposicion' + idFactoria).isVisible() && Ext.getCmp('d_motivoOposicion' + idFactoria).getValue() == ""){
	               	   			return false;
	               	   		}else{
	               	   			return true;
	               	   		}
      					}
		   			}
		   		
		   		]);
		
		
        // id: 207 : TRAMITE HIPOTECARIO : Senyalamiento Vista Oposición.
		this.arrayCampos.push([
		   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		   		]);
		

        // id: 208 : TRAMITE HIPOTECARIO : Auto Estimando Opsición.
		this.arrayCampos.push([
			   			{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha Resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			   			,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"value":"01",allowBlank:false,filtrar:true, "name":"d_resultado","fieldLabel":"Resultado","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_resultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
			   		]);
		
		
        // id: 209 : TRAMITE HIPOTECARIO : Auto Desestimando Opsición.     
		this.arrayCampos.push([
					   			{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha Resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
					   			,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"value":"02",allowBlank:false,filtrar:true, "name":"d_resultado","fieldLabel":"Resultado","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_resultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
					   		]);


		

	// id: 210 : TRAMITE SUBASTA : Escrito sellado solicitando subasta. 
		this.arrayCampos.push([
					   			{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha Solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }			   		
					   		]);		
		
	// id: 211 : TRAMITE SUBASTA : Edicto de subasta + D.O. Señalamiento subasta
	this.arrayCampos.push([
		{"xtype":'numberfield',"name":"d_principal","fieldLabel":"Principal",allowBlank:false}
		,{"xtype":'numberfield',"name":"d_intereses","fieldLabel":"Intereses generados a fecha del señalamiento de subasta.",allowBlank:false, filtrar:true}
		,{"xtype":'numberfield',"name":"d_costasLetrado","fieldLabel":"Costas de letrado",allowBlank:false, filtrar:true}
		,{"xtype":'datefield',"name":"d_fechaAnuncio","fieldLabel":"Fecha anuncio",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		,{"xtype":'numberfield',"name":"d_costasProcurador","fieldLabel":"Costas del procurador",allowBlank:false}
		,{"xtype":'datefield',"name":"d_fechaSenyalamiento","fieldLabel":"Fecha de celebración",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		

	]);

	// id: 212 : TRAMITE SUBASTA : Acuerda suspensión de subasta SAREB
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSuspension","fieldLabel":"Fecha suspensión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeMotivosSuspension, "name":"d_comboMotivoSuspension","fieldLabel":"Motivo suspensión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboMotivoSuspension'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ]);

	
	// id: 213 : TRAMITE SUBASTA : Acta de subasta
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO, "name":"d_comboCelebrada","fieldLabel":"Celebrada",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCelebrada'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO, "name":"d_comboPostores","fieldLabel":"Postores","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboPostores'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":this.storeDecisionSuspension, "name":"d_comboDecisionSuspension","fieldLabel":"Decisión suspensión","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboDecisionSuspension'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":this.storeMotivosSuspension, "name":"d_comboMotivoSuspension","fieldLabel":"Motivo suspensión","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboMotivoSuspension'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	]);
	
	// id: 214 : TRAMITE SUBASTA :Escrito sellado solicitando entrega de cantidades consignadas.
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);
	
	// id: 215 : TRAMITE SUBASTA : Entrega de cantidad consignada
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_importe","fieldLabel":"Importe",allowBlank:true}
	]);
	
	
	
	
	// id: 216 : TRAMITE SUBASTA A TERCEROS: Solicitud suspension de subasta.
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeMotivosSuspension, "name":"d_comboMotivoSuspension","fieldLabel":"Motivo suspensión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboMotivoSuspension'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ]);
	
	
	// id: 217 : TRAMITE SUBASTA A TERCEROS: Registrar resultado de suspensión de subasta
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO, "name":"d_comboSolicitudSubastaSuspendida","fieldLabel":"Solicitud Subasta suspendida",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSolicitudSubastaSuspendida'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ]);
	
	// id: 218 : TRAMITE SUBASTA A TERCEROS: Celebración subasta
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO, "name":"d_comboCelebrada","fieldLabel":"Celebrada",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCelebrada'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO, "name":"d_comboPostores","fieldLabel":"Postores",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboPostores'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":this.storeDecisionSuspension, "name":"d_comboDecisionSuspension","fieldLabel":"Decisión suspensión","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboDecisionSuspension'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
		   		   				,validator : function(v) {
			               	   		if(Ext.getCmp('d_comboCelebrada' + idFactoria).getValue() == "02" && Ext.getCmp('d_comboDecisionSuspension' + idFactoria).getValue() == ""){
			               	   			return false;
			               	   		}else{
			               	   			return true;
			               	   		}
		      					}
				   			}
	                       ,{"xtype":'combo',"store":this.storeMotivosSuspension, "name":"d_comboMotivoSuspension","fieldLabel":"Motivo suspensión","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboMotivoSuspension'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
		   		   				,validator : function(v) {
			               	   		if(Ext.getCmp('d_comboCelebrada' + idFactoria).getValue() == "02" && Ext.getCmp('d_comboMotivoSuspension' + idFactoria).getValue() == ""){
			               	   			return false;
			               	   		}else{
			               	   			return true;
			               	   		}
		      					}
				   			}
	                      ]);
	
	// id: 219 : TRAMITE SUBASTA A TERCEROS: Solicitud mandamiento de pago
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);
	
	// id: 220 : TRAMITE SUBASTA A TERCEROS: Confirmar mandamiento de pago
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_importe","fieldLabel":"Importe",allowBlank:false}
	]);
	
	
	
	
	// id: 221 : CESION DE REMATE : Acordando fecha de cesión
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);
	
	// id: 222 : CESION DE REMATE : Acta cesión de remate
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		,{"xtype":'combo',"store":storeSINO, "name":"d_comboTitularizado","fieldLabel":"Titulizado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboTitularizado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	]);
	
	
	
	
		
	// id: 223 : ADJUDICACIÓN : Solicitud decreto de adjudicacion
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);

	// id: 224 : ADJUDICACIÓN : Notificacion decreto adjudicacion.
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboSubsanacion","fieldLabel":"Requiere subsanación","autoload":true, mode:'local',triggerAction:'all',allowBlank:false,filtradoProcurador:true,resizable:true, 	id:'d_comboSubsanacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	]);
	
	// id: 225 : ADJUDICACIÓN : Solicicitud de testimonio de decreto adjudicacion
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);

	// id: 226 : ADJUDICACIÓN : Confirmar testimonio decreto adjudicacion.
	this.arrayCampos.push([
		{"xtype":'datefield',"name":"d_fechaTestimonio","fieldLabel":"Fecha testimonio",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboSubsanacion","fieldLabel":"Requiere subsanación","autoload":true,allowBlank:false, mode:'local',triggerAction:'all',resizable:true, 	id:'d_comboSubsanacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		,{"xtype":'datefield',"name":"d_fechaEnvioGestoria","fieldLabel":"Fecha envio gestoría",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	]);
	
	
	
	
	
	
    // id: 227 : TRAMITE COSTAS : Solicitud de tasación de costas
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				,{"xtype":'numberfield',"name":"d_cuantiaLetrado","fieldLabel":"Cuantía letrado",id:'d_cuantiaLetrado_id',allowBlank:true, filtrar:true}
					,{"xtype":'numberfield',"name":"d_cuantiaProcurador","fieldLabel":"Cuantía procurador",id:'d_cuantiaProcurador_id',allowBlank:false}
	   		]);
	
    // id: 228 : TRAMITE COSTAS : Tasación de costas del juzgado
	   		this.arrayCampos.push([
	   			   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   			   				,{"xtype":'numberfield',"name":"d_cuantiaLetrado","fieldLabel":"Cuantía letrado",allowBlank:false,id:'d_cuantiaLetrado_id'}
	   							,{"xtype":'numberfield',"name":"d_cuantiaProcurador","fieldLabel":"Cuantía procurador",allowBlank:false,id:'d_cuantiaProcurador_id'}
	   			   		]);
	
     //id: 229 : TRAMITE COSTAS : Impugnación tasación de costas del juzgado
	this.arrayCampos.push([
	                 {"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboImpugnacion","fieldLabel":"Impugnación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboImpugnacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				,{"xtype":'datefield',"name":"d_fechaImpugnacion","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:"d_fechaImpugnacion"+this.idFactoria
                 	   ,validator : function(v) {
	               	   		if(Ext.getCmp('d_comboImpugnacion' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaImpugnacion' + idFactoria).getValue() == ""){
	               	   			return false;
	               	   		}else{
	               	   			return true;
	               	   		}
      					}	
	   				}
//	   				,{"xtype":'combo',"store":storeSINO,"value":"01", "name":"con_vista_si_no","fieldLabel":"Vista",allowBlank:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'con_vista_si_no'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				,{"xtype":'datefield',"name":"d_vistaImpugnacion","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('Y-m-d'), minValue: fechaMinima, id:"d_vistaImpugnacion"+this.idFactoria}
	   				,{"xtype":'combo',"store":this.storeMotivoImpugnacion,"name":"d_comboResultado","fieldLabel":"Motivo impugnación",filtradoProcurador:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
	                 	   ,validator : function(v) {
		               	   		if(Ext.getCmp('d_comboImpugnacion' + idFactoria).getValue() == "01" && Ext.getCmp('d_comboResultado' + idFactoria).getValue() == ""){
		               	   			return false;
		               	   		}else{
		               	   			return true;
		               	   		}
	      					}	
	   				}
	   				]);
	   				
    //id: 230 : TRAMITE COSTAS : Registrar celebración visita
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				]);
	
    //id: 231 : TRAMITE COSTAS : Auto aprobacion de costas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAprobada","fieldLabel":"Aprobada",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAprobada'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'numberfield',"name":"d_cuantiaLetrado","fieldLabel":"Cuantía letrado",allowBlank:false, id:'d_cuantiaLetrado_id'}
						   ,{"xtype":'numberfield',"name":"d_cuantiaProcurador","fieldLabel":"Cuantía procurador",allowBlank:false, id:'d_cuantiaProcurador_id'}
	   				]);
	

	
	
	
	
    //id: 232 : TRAMITE CERTIFICACION CARGAS: Solicitud de certificacion de dominio y cargas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				]);
	
    //id: 233 : TRAMITE CERTIFICACION CARGAS: Registrar certificación
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Obtenida",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 234 : TRAMITE CERTIFICACION CARGAS: Solicitar información cargas anteriores
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Solicitada",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 235 : TRAMITE CERTIFICACION CARGAS: Registrar recepción información de cargas extinguidas o minoradas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeCompletitud,"name":"d_comboCompletitud","fieldLabel":"Información cargas",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCompletitud'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 236 : TRAMITE CERTIFICACION CARGAS: Requerir más información
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				]);
	
	
	
	
	
    //id: 237 : TRAMITE DE INTERESES: Solicitar liquidación de intereses
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaRec","fieldLabel":"Fecha de recepción",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaPre","fieldLabel":"Fecha de presentación",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_intereses","fieldLabel":"Importe intereses",allowBlank:false, filtrar:true}
	   				]);
	
    //id: 238 : TRAMITE DE INTERESES: Registrar resolucion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_importe","fieldLabel":"Intereses",allowBlank:false}
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
    //id: 239 : TRAMITE DE INTERESES: Registrar impugnacion
	this.arrayCampos.push([ 
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha impugnación",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima ,  id:'d_fecha'+this.idFactoria
		   		   				,validator : function(v) {
			               	   		if(Ext.getCmp('d_comboImpugnacion' + idFactoria).getValue() == "01" && Ext.getCmp('d_fecha' + idFactoria).getValue() == ""){
			               	   			return false;
			               	   		}else{
			               	   			return true;
			               	   		}
		      					}   
	                       }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Hay visita",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima ,  id:'d_fechaVista'+this.idFactoria
		   		   				,validator : function(v) {
			               	   		if(Ext.getCmp('d_comboSiNo' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaVista' + idFactoria).getValue() == ""){
			               	   			return false;
			               	   		}else{
			               	   			return true;
			               	   		}
		      					}
	                       }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboImpugnacion","fieldLabel":"Hay impuganción",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboImpugnacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
	
    //id: 240 : TRAMITE DE INTERESES: Registrar Vista
	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha vista",allowBlank:false,filtradoProcurador:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }]);
	
	//id: 241 : TRAMITE DE INTERESES: Registrar Resolucion Vista
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	
	
	
	
	
	//id: 242 : TRAMITE GESTION DE LLAVES: Registrar Cambio de cerradura
	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha cambio cerradura",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }]);
	
	//id: 243 : TRAMITE GESTION DE LLAVES: Registrar Envio de Llaves
	this.arrayCampos.push([
	                       {"xtype":'textfield',"name":"d_nombre","fieldLabel":"Nombre del 1er depositario",allowBlank:false,id:'d_nombre_id'+this.idFactoria}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha envío de llaves a la entidad o al letrado",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	//id: 244 : TRAMITE OCUPANTES: Solicitud de requerimiento documentación a ocupantes
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 245 : TRAMITE OCUPANTES: Registrar recepción de la documentación A
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaFinAle","fieldLabel":"Fecha fin alegaciones",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Bien ocupado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboDocumentacion","fieldLabel":"Documentación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboDocumentacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboInquilino","fieldLabel":"Existe algún inquilino",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboInquilino'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaContrato","fieldLabel":"Fecha contrato arrendamiento",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_nombreArrendatario","fieldLabel":"Nombre arrendatario",allowBlank:true,id:'d_nombreArrendatario'+this.idFactoria}
	                      ]);
	
	//id: 246 : TRAMITE OCUPANTES: Registrar recepción de la documentación B
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaFinAle","fieldLabel":"Fecha fin alegaciones",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Bien ocupado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboDocumentacion","fieldLabel":"Documentación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboDocumentacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboInquilino","fieldLabel":"Existe algún inquilino",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboInquilino'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaContrato","fieldLabel":"Fecha contrato arrendamiento",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_nombreArrendatario","fieldLabel":"Nombre arrendatario",allowBlank:true,id:'d_nombreArrendatario'+this.idFactoria}
	                      ]);
	
	//id: 247 : TRAMITE OCUPANTES: Registrar recepción de la documentación C
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaFinAle","fieldLabel":"Fecha fin alegaciones",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Bien ocupado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboDocumentacion","fieldLabel":"Documentación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboDocumentacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboInquilino","fieldLabel":"Existe algún inquilino",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboInquilino'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaContrato","fieldLabel":"Fecha contrato arrendamiento",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_nombreArrendatario","fieldLabel":"Nombre arrendatario",allowBlank:true,id:'d_nombreArrendatario'+this.idFactoria}
	                      ]);
	
	//id: 248 : TRAMITE OCUPANTES: Presentar escrito alegaciones
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 249 : TRAMITE OCUPANTES: Confirmar visita
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboVista","fieldLabel":"Vista",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboVista'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaVista'+this.idFactoria
	                    	   ,validator : function(v) {
	                    	   		if(Ext.getCmp('d_comboVista' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaVista' + idFactoria).getValue() == ""){
	                    	   			return false;
	                    	   		}else{
	                    	   			return true;
	                    	   		}
	           					} 
	                       }
	                      ]);

	//id: 250 : TRAMITE OCUPANTES: Registrar resolución tiene derecho
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"fecha resolución",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","value":"01",filtrar:true,"fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]); 
	
	//id: 251 : TRAMITE OCUPANTES: Registrar resolución no tiene derecho
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"fecha resolución",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","value":"02",filtrar:true,"fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	
	
	
	
	
	//id: 252 : TRAMITE MORATORIA DE LANZAMIENTO: Registrar solicitud de moratoria
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaFinMoratoria","fieldLabel":"Fecha de fin de moratoria",allowBlank:false,filtradoProcurador:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha de solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 253 : TRAMITE MORATORIA DE LANZAMIENTO: Registrar admisión y emplazamiento
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboAdminEmplaza","fieldLabel":"Admisión y emplazamiento",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdminEmplaza'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboVista","fieldLabel":"Vista","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboVista'+this.idFactoria,displayField:'descripcion',valueField:'codigo'
	                    	   ,validator : function(v) {
	                    	   		if(Ext.getCmp('d_comboAdminEmplaza' + idFactoria).getValue() == "01" && Ext.getCmp('d_comboVista' + idFactoria).getValue() == ""){
	                    	   			return false;
	                    	   		}else{
	                    	   			return true;
	                    	   		}
	           					}   
	                       }
	                       ,{"xtype":'datefield',"name":"d_fechaNotificacion","fieldLabel":"Fecha de notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaNotificacion'+this.idFactoria
//	                    	   ,validator : function(v) {
//	                    	   		if(Ext.getCmp('d_comboAdminEmplaza' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaNotificacion' + idFactoria).getValue() == ""){
//	                    	   			return false;
//	                    	   		}else{
//	                    	   			return true;
//	                    	   		}
//	           					}   
	                       }
	                       ,{"xtype":'datefield',"name":"d_fechaSenyalamiento","fieldLabel":"Fecha de señalamiento",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaSenyalamiento'+this.idFactoria
	                    	   ,validator : function(v) {
	                    	   		if(Ext.getCmp('d_comboVista' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaSenyalamiento' + idFactoria).getValue() == ""){
	                    	   			return false;
	                    	   		}else{
	                    	   			return true;
	                    	   		}
	           					}   
	                       }
	                      ]);
	
	//id: 254 : TRAMITE MORATORIA DE LANZAMIENTO: Presentar conformidad a moratoria
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 255 : TRAMITE MORATORIA DE LANZAMIENTO: Registrar resolución
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaFinMoratoria","fieldLabel":"Fecha fin de moratoria",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboFavDesf","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFavDesf'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	
	
	
	
	
	//id: 256 : TRAMITE DE POSESIÓN: Registrar solicitud de posesión
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO,"name":"d_comboPosesion","fieldLabel":"Posesión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboPosesion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha de solicitud de la posesión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Ocupado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboMoratoria","fieldLabel":"Moratoria",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboMoratoria'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboViviendaHab","fieldLabel":"Vivienda Habitual",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboViviendaHab'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 257 : TRAMITE DE POSESIÓN: Registrar señalamiento posesión
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSenyalamiento","fieldLabel":"Fecha señalamiento para posesión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 258 : TRAMITE DE POSESIÓN: Registrar posesión y decisión lanzamiento
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Ocupado en la realización de la Diligencia",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha realización de la posesión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboFuerzaPublica","fieldLabel":"Necesario fuerza pública",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFuerzaPublica'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboLanzamiento","fieldLabel":"Lanzamiento Necesario",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboLanzamiento'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaSolLanza","fieldLabel":"Fecha solicitud del lanzamiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 259 : TRAMITE DE POSESIÓN: Registrar señalamiento lanzamiento
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha señalamiento para el lanzamiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 260 : TRAMITE DE POSESIÓN: Registrar lanzamiento efectuado
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha lanzamiento efectivo",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboFuerzaPublica","fieldLabel":"Necesario fuerza pública",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFuerzaPublica'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	
	
	//id: 261 : SUBSANACIÓN DECRETO ADJUDICACIÓN: Solicitud de requerimiento documentación a ocupantes
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	//id: 262 : SUBSANACIÓN DECRETO ADJUDICACIÓN: Solicitud de requerimiento documentación a ocupantes
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaEnvio","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	//id: 263 : PROCEDIMIENTO ORDINARIO: Interposicion de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.dsPlazas,allowBlank:false, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		}
		                      		 }
		                        }
	                       ,{"xtype":'datefield',"name":"d_fechaCierre","fieldLabel":"Fecha cierre de la deuda",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                       ,{"xtype":'numberfield',"name":"d_capitalVencido","fieldLabel":"Capital vencido (en el cierre)",allowBlank:false,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesOrdinarios","fieldLabel":"Intereses Ordinarios (en el cierre)",allowBlank:false,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesDemora","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:false,filtrar:true}
	                      ]);
	
	//id: 264 : PROCEDIMIENTO ORDINARIO: Confirmar admision de demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha admisión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.dsPlazas,allowBlank:false, "name":"d_nPlaza","hiddenName":"d_nPlaza",sameValue:"d_plazaJuzgado",fieldLabel:"Plaza",triggerAction: 'all',resizable:true, id:'d_nPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                    		 		select :function(combo){
		            							var idFactoria = combo.id.replace('d_nPlaza','');
		            							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
		            							var storeJuzgado= juzgado.getStore();
		            							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		            							storeJuzgado.on('load', function(){  
	                  								  var foundValue = false;
	                								  storeJuzgado.each(function(record)  
	                								  {
	                									  if(record.get("codigo") == juzgado.getValue()){
	                										  juzgado.setValue(juzgado.getValue());
	                										  foundValue = true;
	                									  }
	
	                								  }, this); 
	                								
	                								  if(!foundValue){
	                									  juzgado.setValue("");
	                								  }
		            							});
		            						}
		                      		 }
		                        }
	                       ,{"xtype":'combo',"store":this.dsJuzgado,"name":"d_numJuzgado","fieldLabel":"Juzgado designado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_numJuzgado'+this.idFactoria,displayField:'descripcion',valueField:'codigo',width:280}
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,validator : function(v) {
          						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
	           					}
	                       	}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 265 : PROCEDIMIENTO ORDINARIO: Confirmar notificacion de demanda
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 266 : PROCEDIMIENTO ORDINARIO: Confirmar si existe oposición
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Contestación demanda",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha de contestación",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaOposicion'+this.idFactoria
	                    	   ,validator : function(v) {
	                    	   		if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaOposicion' + idFactoria).getValue() == ""){
	                    	   			return false;
	                    	   		}else{
	                    	   			return true;
	                    	   		}
	           					}
	                       }
	                       ,{"xtype":'datefield',"name":"d_fechaAudiencia","fieldLabel":"Fecha audiencia prévia",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 267 : PROCEDIMIENTO ORDINARIO: Registrar audiencia previa
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Visto para sentencia",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaJuicio","fieldLabel":"Fecha Juicio",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 268 : PROCEDIMIENTO ORDINARIO: Confirmar celebración de juicio
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 269 : PROCEDIMIENTO ORDINARIO: Registrar resolucion favorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"01",filtrar:true,"name":"d_comboResultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 270 : PROCEDIMIENTO ORDINARIO: Registrar resolucion desfavorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"02",filtrar:true,"name":"d_comboResultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 271 : PROCEDIMIENTO ORDINARIO: Resolución firme
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	
	
	
	//id: 272 : PROCEDIMIENTO MONITORIO: Interposición de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		}
	                      		 }
	                        }
	                       ,{"xtype":'datefield',"name":"d_fechaCierre","fieldLabel":"Fecha cierre de la déuda",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                       ,{"xtype":'numberfield',"name":"d_capitalVencido","fieldLabel":"Capital vencido (en el cierre)",allowBlank:false,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesOrdinarios","fieldLabel":"Intereses Ordinarios (en el cierre)",allowBlank:false,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesDemora","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:false,filtrar:true}
	                      ]);

	//id: 273 : PROCEDIMIENTO MONITORIO: Confirmar admisión de demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima , id:'d_fecha'+this.idFactoria}
	                       ,{"xtype":'combo',"store":this.dsPlazas, "name":"d_nPlaza","hiddenName":"d_nPlaza",sameValue:"d_plazaJuzgado",fieldLabel:"Plaza",triggerAction: 'all',resizable:true, id:'d_nPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                    		 		select :function(combo){
		            							var idFactoria = combo.id.replace('d_nPlaza','');
		            							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
		            							var storeJuzgado= juzgado.getStore();
		            							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		            							storeJuzgado.on('load', function(){  
	                  								  var foundValue = false;
	                								  storeJuzgado.each(function(record)  
	                								  {
	                									  if(record.get("codigo") == juzgado.getValue()){
	                										  juzgado.setValue(juzgado.getValue());
	                										  foundValue = true;
	                									  }
	
	                								  }, this); 
	                								
	                								  if(!foundValue){
	                									  juzgado.setValue("");
	                								  }
		            							});
		            						}
		                      		 }
		                        }
	                       
	                       ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:280,mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Juzgado designado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_numJuzgado' + this.idFactoria }
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento_id'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                       	}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	
	//id: 274 : PROCEDIMIENTO MONITORIO: Confirmar notificación requerimiento de pago
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false,filtradoProcurador:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 275 : PROCEDIMIENTO MONITORIO: Confirmar oposicion y cuantía
	this.arrayCampos.push([
							{"xtype":'textfield',"name":"d_procedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,sameValue:"d_numProcedimiento",id:'d_procedimiento'+this.idFactoria
									,validator : function(v) {
											return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
									}
							}
							,{"xtype":'textfield',"name":"d_deuda","fieldLabel":"Principal",allowBlank:false,id:'d_deuda'+this.idFactoria}
							,{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
							,{"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha notificación",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaOposicion'+this.idFactoria
								,validator : function(v) {
								   		if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaOposicion' + idFactoria).getValue() == ""){
								   			return false;
								   		}else{
								   			return true;
								   		}
									} 	
							}
							,{"xtype":'datefield',"name":"d_fechaJuicio","fieldLabel":"Fecha Juicio",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima , id:'d_fechaJuicio'+this.idFactoria
								,validator : function(v) {
							   		if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaJuicio' + idFactoria).getValue() == ""){
							   			return false;
							   		}else{
							   			return true;
							   		}
								}	
							}
	                      ]);
	
	
	
	
	
	

	
	//id: 276 : PROCEDIMIENTO VERBAL: INTERPOSICION DE LA DEMANDA
	this.arrayCampos.push([
							{"xtype":'datefield',"name":"d_fechainterposicion","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		}
		                      		 }
		                        }
	                       	,{"xtype":'datefield',"name":"d_fechaCierre","fieldLabel":"Fecha cierre de la déuda",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
							,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
		                    ,{"xtype":'numberfield',"name":"d_capitalVencido","fieldLabel":"Capital vencido (en el cierre)",allowBlank:false,filtrar:true}
		                    ,{"xtype":'numberfield',"name":"d_interesesOrdinarios","fieldLabel":"Intereses Ordinarios (en el cierre)",allowBlank:false,filtrar:true}
		                    ,{"xtype":'numberfield',"name":"d_interesesDemora","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:false,filtrar:true}
	                      ]);
	
	//id: 277 : PROCEDIMIENTO VERBAL: CONFIRMAR ADMISIÓN DE DEMANDA
	this.arrayCampos.push([
							{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha admisión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		                    ,{"xtype":'combo',"store":this.dsPlazas,allowBlank:false, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                    		 		select :function(combo){
		            							var idFactoria = combo.id.replace('d_comboPlaza','');
		            							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
		            							var storeJuzgado= juzgado.getStore();
		            							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		            							storeJuzgado.on('load', function(){  
	                  								  var foundValue = false;
	                								  storeJuzgado.each(function(record)  
	                								  {
	                									  if(record.get("codigo") == juzgado.getValue()){
	                										  juzgado.setValue(juzgado.getValue());
	                										  foundValue = true;
	                									  }
	
	                								  }, this); 
	                								
	                								  if(!foundValue){
	                									  juzgado.setValue("");
	                								  }
		            							});
		            						}
		                      		 }
		                        }
							,{"xtype":'combo',"store":this.dsJuzgado,"name":"d_numJuzgado","fieldLabel":"Nº Juzgado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_numJuzgado'+this.idFactoria,displayField:'descripcion',valueField:'codigo',width:280}
							,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento'+this.idFactoria
								,validator : function(v) {
										return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
								}
							}
							,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmisionDemanda","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmisionDemanda'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 278 : PROCEDIMIENTO VERBAL: CONFIRMAR NOTIFICACIÓN DE DEMANDA
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'datefield',"name":"d_fechaJuicio","fieldLabel":"Fecha juicio",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 279 : PROCEDIMIENTO VERBAL: REGISTRAR JUICIO
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha celebración",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 280 : PROCEDIMIENTO VERBAL: REGISTRAR RESOLUCION DESFAVORABLE
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"value":"02","name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 281 : PROCEDIMIENTO VERBAL: REGISTRAR RESOLUCION FAVORABLE 
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"value":"01","name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 282 : PROCEDIMIENTO VERBAL: RESOLUCIÓN FIRME
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	
	//id: 283 : PROCEDIMIENTO VERBAL DESDE MONITORIO: REGISTRAR JUICIO VERBAL
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha celebración",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                       	}
	                      ]);
	
	//id: 284 : PROCEDIMIENTO VERBAL DESDE MONITORIO: REGISTRAR RESOLUCIÓN DESFAVORABLE
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 285 : PROCEDIMIENTO VERBAL DESDE MONITORIO: REGISTRAR RESOLUCIÓN FAVORABLE
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 286 : PROCEDIMIENTO VERBAL DESDE MONITORIO: RESOLUCIÓN FIRME
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	
	//id: 287 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Solicitar certificación de dominio y cargas
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 288 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Registrar certificación
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Obtenida",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 289 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Solicitar información cargas anteriores
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboResultado","fieldLabel":"Solicitada",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id : 'd_fecha' + idFactoria
		                    	   ,validator : function(v) {
		                    	   		if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_fecha' + idFactoria).getValue() == ""){
		                    	   			return false;
		                    	   		}else{
		                    	   			return true;
		                    	   		}
		           					}
		                       }
	                      ]);
	
	//id: 290 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Registrar recepción información cargas extinguidas o minoradas
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeCompletitud,"name":"d_comboCompletitud","fieldLabel":"Información cargas","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCompletitud'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 291 : T. CERTIFICADO DE CARGAS Y REVISIÓN: Requerir información que falta
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	
	//id: 292 : T. EMBARGO DE SALARIOS: Solicitar la notificacion retención al pagador
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'numberfield',"name":"d_importeNom","fieldLabel":"Importe base retención",allowBlank:true,filtrar:true}
	                       	,{"xtype":'numberfield',"name":"d_importeRet","fieldLabel":"Importe de retención",allowBlank:false, filtrar:true}
	                      ]);
	
	//id: 293 : T. EMBARGO DE SALARIOS: Confirmar requerimiento de resultado
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":storeSINO,"name":"d_comboRequerido","fieldLabel":"Requerido",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboRequerido'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'numberfield',"name":"d_importeNom","fieldLabel":"Importe base retención",allowBlank:true,filtrar:true}
	                       	,{"xtype":'numberfield',"name":"d_importeRet","fieldLabel":"Importe de retención",allowBlank:true, filtrar:true}
	                      ]);
	
	//id: 294 : T. EMBARGO DE SALARIOS: Confirmar retenciones
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDCorrectoCobro,"name":"d_comboCorr","fieldLabel":"Situación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCorr'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 295 : T. EMBARGO DE SALARIOS: Confirmar retenciones
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	//id: 296 : T. VALORACIÓN INMUEBLE: Solicitar avaluo
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 297 : T. VALORACIÓN INMUEBLE: Obtencion avaluo
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 298 : T. VALORACIÓN INMUEBLE: Presentar alegaciones
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 299 : T. VALORACIÓN INMUEBLE:  H058_RegistrarResultado
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_combo", filtradoProcurador:true, "fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_combo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	
	
	
	
	//id: 300 : T. VALORACIÓN MUEBLE: solicitar justiprecio
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 301 : T. VALORACIÓN MUEBLE: registrar justiprecio
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaRegistro","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'numberfield',"name":"d_cuantia","fieldLabel":"Cuantía",allowBlank:false, filtradoProcurador:true}
	                      ]);
	
	
	
	
	
	
	//id: 302 : T. MEJORA EMBARGO: solicitud mejora embargo
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSol","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 303 : T. MEJORA EMBARGO: Registro decreto de embargo
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":storeSINO,"name":"d_comboBienes","fieldLabel":"Existen bienes embargables",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboBienes'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 304 : T. MEJORA EMBARGO: Registrar anotacion en registro
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de anotación de los embargos",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":storeSINO,"name":"d_comboBienes","fieldLabel":"Existen bienes no apremiados","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboBienes'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	
	
	
	
	
	
	//id: 305 : P. CAMBIARIO: Interposicion de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',allowBlank:false, resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		}
		                      		 }
		                     }
	                       ,{"xtype":'datefield',"name":"d_fechaCierre","fieldLabel":"Fecha cierre de la deuda",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                       ,{"xtype":'numberfield',"name":"d_capitalVencido","fieldLabel":"Capital vencido (en el cierre)",allowBlank:true,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesOrdinarios","fieldLabel":"Intereses Ordinarios (en el cierre)",allowBlank:true,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesDemora","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:true,filtrar:true}
	                      ]);
	
	//id: 306 : P. CAMBIARIO: Confirmar admision de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",allowBlank:false,triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                      		 		select :function(combo){
		              							var idFactoria = combo.id.replace('d_comboPlaza','');
		              							var juzgado=Ext.getCmp('d_comboJuzgado' + idFactoria);
		              							var storeJuzgado= juzgado.getStore();
		              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		            							storeJuzgado.on('load', function(){  
	                  								  var foundValue = false;
	                								  storeJuzgado.each(function(record)  
	                								  {
	                									  if(record.get("codigo") == juzgado.getValue()){
	                										  juzgado.setValue(juzgado.getValue());
	                										  foundValue = true;
	                									  }
	
	                								  }, this); 
	                								
	                								  if(!foundValue){
	                									  juzgado.setValue("");
	                								  }
		            							});
		              						}
		                      		 }
		                        }
		                     ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:280,mode:'local', "name":"d_comboJuzgado","hiddenName":"d_comboJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_comboJuzgado' + this.idFactoria }
		                     ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false, id:'d_numProcedimiento_id'+this.idFactoria
		         				,validator : function(v) {
		         						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		         				}
		                      }
		                     ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmision","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmision'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		                     ,{"xtype":'combo',"store":storeSINO,"name":"d_comboBienes","fieldLabel":"Existen bienes registrables",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboBienes'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 307 : P. CAMBIARIO: Registrar anotación en registro
	this.arrayCampos.push([
	                       /*{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_repetir","fieldLabel":"Activar alerta periódica",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_repetir'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}*/
	                      ]);
	
	//id: 308 : P. CAMBIARIO: Confirmar notificación requerimiento de pago
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 309 : P. CAMBIARIO: Registrar demanda oposición
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO,"name":"d_comboOposicion","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOposicion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 310 : P. CAMBIARIO: Registrar auto despachando ejecucion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 311 : P. CAMBIARIO: Registrar juicio y comparecencia
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 312 : P. CAMBIARIO: Registrar resolución desfavorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"02","name":"d_comboResultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 313 : P. CAMBIARIO: Registrar resolución favorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"01","name":"d_comboResultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 314 : P. CAMBIARIO: Resolución firme
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	//id: 315 : P. DE DEPOSITO: Solicitar nombramiento de depositario
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 316 : P. DE DEPOSITO: Nombramiento de depositario
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 317 : P. DE DEPOSITO: Aceptacion cargo depositario
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 318 : P. DE DEPOSITO: solicitar remocion depósito
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 319 : P. DE DEPOSITO: Acuerdo entrega depositario
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	//id: 320 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Interposicion de la demanda - marcado de bienes
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaInterposicion","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                        ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_nPlaza","hiddenName":"d_nPlaza",fieldLabel:"Plaza",triggerAction: 'all',resizable:true, id:'d_nPlaza'+this.idFactoria
	                       	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                       		,listeners:{afterRender:function(combo){
	                       			 combo.mode='remote';
	                       		 		}
	                       		 }
	                         }
		                       ,{"xtype":'datefield',"name":"d_fechaCierre","fieldLabel":"Fecha cierre",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
		                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
		                       ,{"xtype":'numberfield',"name":"d_capitalVencido","fieldLabel":"Capital vencido (en el cierre)",allowBlank:false,filtrar:true}
		                       ,{"xtype":'numberfield',"name":"d_capitalNoVencido","fieldLabel":"Capital no vencido (en el cierre)",allowBlank:false,filtrar:true}
		                       ,{"xtype":'numberfield',"name":"d_interesesOrdinarios","fieldLabel":"Intereses Ordinarios (en el cierre)",allowBlank:false,filtrar:true}
		                       ,{"xtype":'numberfield',"name":"d_interesesDemora","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:false,filtrar:true}
	                        
	                      ]);
	
	
	//id: 321 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Auto despachando ejecucion - marcado de bienes decreto embargo
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_comboPlaza",allowBlank:false,"hiddenName":"d_comboPlaza", sameValue:"d_nPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		},
	                      		 		select :function(combo){
	              							var idFactoria = combo.id.replace('d_comboPlaza','');
	              							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
	              							var storeJuzgado= juzgado.getStore();
	              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
	            							storeJuzgado.on('load', function(){  
	              								  var foundValue = false;
	            								  storeJuzgado.each(function(record)  
	            								  {
	            									  if(record.get("codigo") == juzgado.getValue()){
	            										  juzgado.setValue(juzgado.getValue());
	            										  foundValue = true;
	            									  }
	
	            								  }, this); 
	            								
	            								  if(!foundValue){
	            									  juzgado.setValue("");
	            								  }
	            							});
	              						}
	                      		 }
	                        }
	                       
	                       ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:280,mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_numJuzgado' + this.idFactoria }
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento_id'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                        }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmisionDemanda","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmisionDemanda'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_bienesEmbargables","fieldLabel":"Existen bienes embargables",filtradoProcurador:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_bienesEmbargables'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]); 
	
	//id: 322 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Auto despachando ejecucion - marcado de bienes decreto embargo (clausulas abusivas)
	this.arrayCampos.push([
	                       {"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",sameValue:"d_nPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		},
	                      		 		select :function(combo){
	              							var idFactoria = combo.id.replace('d_comboPlaza','');
	              							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
	              							var storeJuzgado= juzgado.getStore();
	              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
	            							storeJuzgado.on('load', function(){  
	              								  var foundValue = false;
	            								  storeJuzgado.each(function(record)  
	            								  {
	            									  if(record.get("codigo") == juzgado.getValue()){
	            										  juzgado.setValue(juzgado.getValue());
	            										  foundValue = true;
	            									  }
	
	            								  }, this); 
	            								
	            								  if(!foundValue){
	            									  juzgado.setValue("");
	            								  }
	            							});
	              						}
	                      		 }
	                        }
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:280,mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_numJuzgado' + this.idFactoria }
	                       ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_numProcedimiento_id'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                        }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmisionDemanda","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmisionDemanda'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 323 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Auto despachando ejecucion - marcado de bienes decreto embargo (clausulas abusivas)
	this.arrayCampos.push([
	                       /*{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_repetir","fieldLabel":"Activar alerta periódica",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_repetir'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}*/
	                      ]);
	
	//id: 324 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Confirmar notificacion requerimiento de pago
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboConfirmacionReqPago","fieldLabel":"Resultado notificación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboConfirmacionReqPago'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima ,id:'d_fecha'+this.idFactoria}
	                      ]);
	
	//id: 325 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Confirmar si existe oposición
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboConfirmacion","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboConfirmacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha oposición",allowBlank:true,filtradoProcurador:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima , id:'d_fecha'+this.idFactoria
	                    	   ,validator : function(v) {
	                    	   		if(Ext.getCmp('d_comboConfirmacion' + idFactoria).getValue() == "01" && Ext.getCmp('d_fecha' + idFactoria).getValue() == ""){
	                    	   			return false;
	                    	   		}else{
	                    	   			return true;
	                    	   		}
	           					}
	                       }
	                      ]);
	
	//id: 326 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Confirmar presentación de impugnación
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_motivo","fieldLabel":"Indicar motivo oposición",allowBlank:false,filtrar:true,id:'d_motivo'+this.idFactoria}
	                      ]);
	
	//id: 327 : T. EJECUCIÓN TÍTULO NO JUDICIAL:Confirmar si hay vista
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboHayVista","fieldLabel":"Hay vista",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboHayVista'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true,filtradoProcurador:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima , id:'d_fechaVista'+this.idFactoria
	                    	   ,validator : function(v) {
	                    	   		if(Ext.getCmp('d_comboHayVista' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaVista' + idFactoria).getValue() == ""){
	                    	   			return false;
	                    	   		}else{
	                    	   			return true;
	                    	   		}
	           					}   
	                       }
	                      ]);
	
	//id: 328 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Registrar celebración vista
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 329 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Registrar resolucion desfavorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_combo","fieldLabel":"Resultado",allowBlank:false,filtrar:true, "value":"02",filtrar:true, "autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_combo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 330 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Registrar resolucion favorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_combo","fieldLabel":"Resultado",allowBlank:false,filtrar:true, "value":"01",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_combo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 331 : T. EJECUCIÓN TÍTULO NO JUDICIAL: Resolución firme
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaResolucion","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
    
	
	
	
	
	
	//id: 332 : T. EJECUCIÓN TÍTULO JUDICIAL: Interposición de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",allowBlank:false,fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		},
	                      		 		select :function(combo){
	              							var idFactoria = combo.id.replace('d_plazaJuzgado','');
	              							var juzgado=Ext.getCmp('d_numJuzgado' + idFactoria);
	              							var storeJuzgado= juzgado.getStore();
	              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
	            							storeJuzgado.on('load', function(){  
	              								  var foundValue = false;
	            								  storeJuzgado.each(function(record)  
	            								  {
	            									  if(record.get("codigo") == juzgado.getValue()){
	            										  juzgado.setValue(juzgado.getValue());
	            										  foundValue = true;
	            									  }
	
	            								  }, this); 
	            								
	            								  if(!foundValue){
	            									  juzgado.setValue("");
	            								  }
	            							});
	              						}
	                      		 }
	                        }
	                       ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:280,mode:'local', "name":"d_numJuzgado","hiddenName":"d_numJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_numJuzgado' + this.idFactoria }
	                      ]);
	
	//id: 333 : T. EJECUCIÓN TÍTULO JUDICIAL: Auto despachando ejecucion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_nProc","fieldLabel":"Nº de procedimiento",allowBlank:true,id:'d_nProc'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                        }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboBienesRegistrables","fieldLabel":"Existen bienes registrables",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboBienesRegistrables'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 334 : T. EJECUCIÓN TÍTULO JUDICIAL: Auto despachando ejecucion clausulas abusivas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'textfield',"name":"d_nProc","fieldLabel":"Nº de procedimiento",allowBlank:false,id:'d_nProc'+this.idFactoria
		           				,validator : function(v) {
		           						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		           				}
	                        }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboBienesRegistrables","fieldLabel":"Existen bienes registrables",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboBienesRegistrables'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 335 : T. EJECUCIÓN TÍTULO JUDICIAL: Confirmar anotacion en registro
	this.arrayCampos.push([
	                       /*{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_repetir","fieldLabel":"Activar alerta periódica",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_repetir'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}*/
	                      ]);
	
	//id: 336 : T. EJECUCIÓN TÍTULO JUDICIAL: Confirmar notificacion positiva
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboSiNo","value":"01",filtrar:true,"fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);   
	
	
	//id: 337 : T. EJECUCIÓN TÍTULO JUDICIAL: Registrar oposicion vista
	this.arrayCampos.push([
	                       {"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Existe oposición",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha oposición",allowBlank:true,filtradoProcurador:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fecha'+this.idFactoria
	                     	   ,validator : function(v) {
		   	               	   		if(Ext.getCmp('d_comboSiNo' + idFactoria).getValue() == "01" && Ext.getCmp('d_fecha' + idFactoria).getValue() == ""){
		   	               	   			return false;
		   	               	   		}else{
		   	               	   			return true;
		   	               	   		}
	         					}   
	                       }
	                       ,{"xtype":'textfield',"name":"d_motivo","fieldLabel":"Motivo oposición",allowBlank:true,filtradoProcurador:true,filtrar:true,id:'d_motivo'+this.idFactoria}
	                      ]);
	
	//id: 338 : T. EJECUCIÓN TÍTULO JUDICIAL: Confirmar presentar impugnacion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 339 : T. EJECUCIÓN TÍTULO JUDICIAL: Hay Vista
	this.arrayCampos.push([
	                       	{"xtype":'combo',"store":storeSINO,"name":"d_comboSiNo","fieldLabel":"Hay vista",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:true,filtradoProcurador:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima , id:'d_fechaVista'+this.idFactoria
	                     	   ,validator : function(v) {
		   	               	   		if(Ext.getCmp('d_comboSiNo' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaVista' + idFactoria).getValue() == ""){
		   	               	   			return false;
		   	               	   		}else{
		   	               	   			return true;
		   	               	   		}
	         					}
	                       }
	                      ]);
	
	//id: 340 : T. EJECUCIÓN TÍTULO JUDICIAL: Registrar Vista
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 341 : T. EJECUCIÓN TÍTULO JUDICIAL: Registrar resolución desfavorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"02","name":"d_resultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_resultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 342 : T. EJECUCIÓN TÍTULO JUDICIAL: Registrar Favorable
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"value":"01","name":"d_resultado","fieldLabel":"Resultado",readOnly: true, allowBlank:false,filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_resultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 343 : T. EJECUCIÓN TÍTULO JUDICIAL: Resolución firme
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	
	
	//id: 344 : P. DE PRECINTO: Solicitud de precinto
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 345 : P. DE PRECINTO: Acuerdo de precinto
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 346 : P. DE PRECINTO: Confirmar fecha precinto
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	//id: 347 : T. INVESTIGACIÓN JUDICIAL: Solicitud de investigación judicial 
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha solicitud",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	//id: 348 : T. INVESTIGACIÓN JUDICIAL: Registrar resultado de investigación
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboRegistro","fieldLabel":"Resultados",allowBlank:false,filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboRegistro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAgTribut","fieldLabel":"Agencia tributaria",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAgTribut'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboSegSocial","fieldLabel":"Seg. social",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSegSocial'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboCatastro","fieldLabel":"Catastro",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCatastro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAyto","fieldLabel":"Ayuntamiento",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAyto'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboOtros","fieldLabel":"Otros",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOtros'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'numberfield',"name":"d_solvencia","fieldLabel":"Solvencia encontrada",allowBlank:true}
	                       	,{"xtype":'numberfield',"name":"d_impuestos","fieldLabel":"Ingresos encontrados",allowBlank:true,filtrar:true}
	                       	
	                      ]);
	
	//id: 349 : T. INVESTIGACIÓN JUDICIAL: Revisar resultado de investigación y actualizacion de datos
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboRegistro","fieldLabel":"Resultados",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboRegistro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAgTribut","fieldLabel":"Agesncia tributaria",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAgTribut'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboSegSocial","fieldLabel":"Seg. social",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSegSocial'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboCatastro","fieldLabel":"Catastro",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCatastro'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAyto","fieldLabel":"Ayuntamiento",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAyto'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboOtros","fieldLabel":"Otros",filtrar:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOtros'+this.idFactoria,displayField:'descripcion',valueField:'codigo'},{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboAyto","fieldLabel":"Ayuntamiento","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAyto'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'numberfield',"name":"d_solvencia","fieldLabel":"Solvencia encontrada",allowBlank:true}
	                       	,{"xtype":'numberfield',"name":"d_impuestos","fieldLabel":"Ingresos encontrados",allowBlank:true}
	                      ]);
	
	
	
	
	//id: 350 : T. DE CONSIGNACIÓN: Escrito sellado acreditando consignación
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                      ]);
	
	
	
	
	
	
	
    // id: 351 : TRAMITE COSTAS CONTRA ENTIDAD : Solicitud costas entidad
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	// id: 352 : TRAMITE COSTAS CONTRA ENTIDAD : Tasación de costas
	this.arrayCampos.push([
	   	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha decreto",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   	   				,{"xtype":'numberfield',"name":"d_costasProcurador","fieldLabel":"Costas del procurador",allowBlank:false}
	   	   				,{"xtype":'numberfield',"name":"d_costasLetrado","fieldLabel":"Costas de letrado",allowBlank:false}
	   	   				,{"xtype":'numberfield',"name":"d_suplidos","fieldLabel":"Suplidos",allowBlank:false}
	   	   				,{"xtype":'combo',"store":storeSINO,"value":"02", "name":"d_comboImpugnacion","fieldLabel":"Presentación de impugnación","autoload":true, mode:'local',triggerAction:'all',resizable:true, 	id:'d_comboImpugnacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   	   		]);
	
    // id: 353 : TRAMITE COSTAS CONTRA ENTIDAD : Escrito sellado impugnando costas
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha presentación impugnación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:false, filtradoProcurador:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				,{"xtype":'combo',"store":this.storeDDIndebidaExcesiva,"name":"d_tipoImpugnacion","fieldLabel":"Tipo de impugnación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_tipoImpugnacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   		]);
    
	// id: 354 : TRAMITE COSTAS CONTRA ENTIDAD : Diligencia señalando vista impugnación tasación de costas
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	// id: 355 : TRAMITE COSTAS CONTRA ENTIDAD : Decreto aprobando tasación de costas
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de resolución",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   				,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_resultado","fieldLabel":"Resultado de la resolución",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_resultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   		]);
	
	// id: 356 : TRAMITE COSTAS CONTRA ENTIDAD : Escrito sellado acreditando consignación
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de pago",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	
	
	
	
	
	// id: 357 : TRAMITE NOTIFICACION : Escrito sellado solicitando notificación en otros domicilios.
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	// id: 358 : TRAMITE NOTIFICACION : Escrito sellado solicitando averiguación domiciliaria.
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	// id: 359 : TRAMITE NOTIFICACION : Resolución acuerda notificación en otros domicilios.
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fechaNotificacion","fieldLabel":"Fecha de notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	// id: 360 : TRAMITE NOTIFICACION : Resolución acuerda averiguación domiciliaria.
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fechaNotificacion","fieldLabel":"Fecha de notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	// id: 361 : TRAMITE NOTIFICACION : Diligencia de requerimiento.
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fechaRequerimiento","fieldLabel":"Fecha de requerimiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                   	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboPositivoNegativo","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboPositivoNegativo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
					,{"xtype":'textfield',"name":"d_direccion","fieldLabel":"Direccion",allowBlank:true,id:'d_direccion'+this.idFactoria}

	   		]);
	
	// id: 362 : TRAMITE NOTIFICACION : Escrito sellado solicitando notificación por edictos
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fechaPresentacion","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	// id: 363 : TRAMITE NOTIFICACION : D.O. acordando notificación por edictos
	this.arrayCampos.push([
	   				{"xtype":'datefield',"name":"d_fechaExpedicion","fieldLabel":"Fecha de expedición",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	   		]);
	
	
	
	
	// id: 364 : TRAMITE CESIÓN DE REMATE : Acta de subasta
	this.arrayCampos.push([
	               		{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	               	]);
	
	
	
	//id: 365 : T. EJECUCIÓN TÍTULO JUDICIAL: Confirmar notificacion negativa
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboSiNo","value":"02",filtrar:true,"fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboSiNo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);  
	
    //id: 366 : PROCEDIMIENTO MONITORIO: Decreto de fin de monitorio
    this.arrayCampos.push([
                               {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de notificación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                      ]);
   

    //id: 367 : PROCEDIMIENTO MONITORIO: Diligencia que cita a las partes para vista
    this.arrayCampos.push([
                               {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de señalamiento vista",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                      ]);
   
    //id: 368 : PROCEDIMIENTO MONITORIO: Requerimiento interponer demanda ordinario
    this.arrayCampos.push([
                               {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha vencimiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                           ]);
   
   
    //id: 369 : VIGILANCIA CADUCIDAD DE EMBARGO: Mandamiento cumplimentado de anotación de embargo en el registro
    this.arrayCampos.push([
                               {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha vencimiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                                  ,{"xtype":'combo',"store":storeSINO, "name":"d_comboAlerta","fieldLabel":"Activar alerta periódica",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true,     id:'d_comboAlerta'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
                               ]);
   
    //id: 370 : TRÁMITE DE BIENES INMUEBLES: Decreto de firmeza
    this.arrayCampos.push([
                               {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha firmeza",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                           ]);
       
    //id: 371 : PROCEDIMIENTO HIPOTECARIO : Registrar certificación de cargas
    this.arrayCampos.push([
                               {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                                  ,{"xtype":'combo',"store":storeSINO, "name":"d_cargasPrevias","fieldLabel":"Tiene cargas Previas",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true,id:'d_cargasPrevias'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
                                  ,{"xtype":'numberfield',"name":"d_cuantiaCargasPrevias","fieldLabel":"Cuantía cargas previas",allowBlank:true,filtradoProcurador:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima , id:'d_cuantiaCargasPrevias'+this.idFactoria
       	                     	   ,validator : function(v) {
       	                     		   	if(this.esProcurador)
       	                     			   return true;
	       	                     		   	else{
	       		   	               	   		if(Ext.getCmp('d_cargasPrevias' + idFactoria).getValue() == "01" && Ext.getCmp('d_cuantiaCargasPrevias' + idFactoria).getValue() == ""){
	       		   	               	   			return false;
	       		   	               	   		}else{
	       		   	               	   			return true;
	       		   	               	   		}
       		   	               	   		}
       	         					}
       	                       }
                                  
                                  
                               ]);

    // id: 372 : TRAMITE HIPOTECARIO (CAJAMAR) : Confirmar si existe oposición.
    this.arrayCampos.push([
        {"xtype":'datefield',"name":"d_fechaOposicion","fieldLabel":"Fecha oposición",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaOposicion'+this.idFactoria
            ,validator: function(v) {
                if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_fechaOposicion' + idFactoria).getValue() == ""){
                    return false;
                } else {
                    return true;
                }
            }
        }
        ,{"xtype":'datefield',"name":"d_fechaComparecencia","fieldLabel":"Fecha comparecencia",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id:'d_fechaComparecencia'+this.idFactoria}
        ,{"xtype":'combo',"store":storeSINO, "name":"d_comboResultado","fieldLabel":"Oposición","autoload":true,allowBlank:false,  mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
        ,{"xtype":'textarea',"name":"d_motivoOposicion","fieldLabel":"Motivo oposición",allowBlank:true,filtrar:true,width:285, id:'d_motivoOposicion'+this.idFactoria
            ,validator: function(v) {
                if(Ext.getCmp('d_comboResultado' + idFactoria).getValue() == "01" && Ext.getCmp('d_motivoOposicion' + idFactoria).isVisible() && Ext.getCmp('d_motivoOposicion' + idFactoria).getValue() == ""){
                    return false;
                } else {
                    return true;
                }
            }
        }
        ,{"xtype": 'datefield', "name": "d_fechaFinAlegaciones", "fieldLabel": "Fecha fin alegaciones", allowBlank: true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, id: 'd_fechaFinAlegaciones' + this.idFactoria}
        ,{"xtype":'combo',"store":storeSINO, "name":"d_alegaciones","fieldLabel":"Presentar alegaciones","autoload":true, filtrar:true, mode:'local',triggerAction:'all',resizable:true, id:'d_alegaciones'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
    ]);

    //id: 373 : PROCEDIMIENTO HIPOTECARIO (CAJAMAR) : Cumplimentar mandamiento de certificación de cargas
    this.arrayCampos.push([
       {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    ]);

    //id: 374 : PROCEDIMIENTO HIPOTECARIO (CAJAMAR) : Solicitud oficio acreedores anteriores
    this.arrayCampos.push([
       {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    ]);

    //id: 375 : PROCEDIMIENTO HIPOTECARIO (CAJAMAR): Registrar resolución Juzgado
    this.arrayCampos.push([
        {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype": 'combo', "store": this.storeDDPositivoNegativo, "name": "d_resultado", "fieldLabel": "Resultado", allowBlank: true, "autoload": true, mode: 'local', triggerAction: 'all', resizable: true, id: 'd_resultado' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
        ,{"xtype": 'numberfield', "name": "d_cuantiaCargasPrevias", "fieldLabel": "Cuantía cargas previas", allowBlank: true, filtradoProcurador: true, id: 'd_cuantiaCargasPrevias' + this.idFactoria}
    ]);

    //id: 376 : PROCEDIMIENTO HIPOTECARIO (CAJAMAR): ESCRITO DE ALEGACIONES
    this.arrayCampos.push([
        {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha presentación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype": 'combo', "store": storeSINO, "name": "d_comparecencia", "fieldLabel": "Comparecencia", allowBlank: false, "autoload": true, mode: 'local', triggerAction: 'all', resizable: true, id: 'd_comparecencia' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
        ,{"xtype": 'datefield', "name": "d_fechaComparecencia", "fieldLabel": "Fecha comparecencia", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    ]);

    //id: 377 : TRAMITE DE POSESIÓN (CAJAMAR): Registrar solicitud de posesión
    this.arrayCampos.push([
       {"xtype": 'combo',"store":storeSINO, "name": "d_comboPosesion","fieldLabel":"Posesión", allowBlank:false, "autoload":true, mode: 'local',triggerAction: 'all', resizable: true, id:'d_comboPosesion'+this.idFactoria,displayField:'descripcion', valueField:'codigo'}
       ,{"xtype": 'datefield',"name":"d_fechaSolicitud", "fieldLabel": "Fecha de solicitud de la posesión", allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       ,{"xtype": 'combo', "store": storeSINO, "name": "d_comboOcupado", "fieldLabel": "Ocupado", allowBlank:false, "autoload":true, mode: 'local',triggerAction: 'all', resizable: true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion', valueField:'codigo'}
       ,{"xtype": 'combo', "store": storeSINO, "name": "d_comboMoratoria", "fieldLabel": "Moratoria", allowBlank:false, "autoload":true, mode: 'local',triggerAction: 'all', resizable: true, id:'d_comboMoratoria'+this.idFactoria,displayField:'descripcion', valueField:'codigo'}
       ,{"xtype": 'combo', "store": storeSINO, "name": "d_comboViviendaHab", "fieldLabel": "Vivienda Habitual", allowBlank:false, "autoload":true, mode: 'local',triggerAction: 'all', resizable: true, id:'d_comboViviendaHab'+this.idFactoria,displayField:'descripcion', valueField:'codigo'}
       ,{"xtype": 'combo', "store": storeSINO, "name": "d_comboArrendamientoValido", "fieldLabel": "Contrato arrendamiento válido", filtrar: true, allowBlank: false, "autoload": true, mode: 'local', triggerAction: 'all', resizable: true, id:'d_comboArrendamientoValido' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
    ]);

    //id: 378 : TRAMITE DE POSESIÓN (CAJAMAR): Diligencia judicial de la posesión
    this.arrayCampos.push([
        {"xtype": 'combo', "store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Ocupado en la realización de la Diligencia",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
       ,{"xtype": 'datefield', "name":"d_fecha","fieldLabel":"Fecha realización de la posesión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       ,{"xtype": 'combo', "store":storeSINO,"name":"d_comboFuerzaPublica","fieldLabel":"Necesario fuerza pública",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFuerzaPublica'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
       ,{"xtype": 'combo', "store":storeSINO,"name":"d_comboLanzamiento","fieldLabel":"Lanzamiento Necesario",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboLanzamiento'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
    ]);

    // id: 379 : TRAMITE SUBASTA A TERCEROS (CAJAMAR): Registrar resultado de suspensión de subasta
    this.arrayCampos.push([
        {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha resolución", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype": 'combo', "store": storeSINO, "name": "d_comboSuspension", "fieldLabel": "Subasta suspendida", allowBlank: false, "autoload": true, mode: 'local', triggerAction: 'all', resizable: true, id: 'd_comboSuspension' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
    ]);

    // id: 380 : TRAMITE SUBASTA A TERCEROS (CAJAMAR): Confirmar mandamiento de pago
    this.arrayCampos.push([
       {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha recepción", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       ,{"xtype": 'datefield', "name": "d_fechaEnvio", "fieldLabel": "Fecha envío", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       ,{"xtype": 'numberfield', "name": "d_importe", "fieldLabel": "Importe", allowBlank: false}
    ]);

    // id: 381 : TRAMITE DE POSESIÓN (CAJAMAR): Notificación deudor subrogación contrato alquiler
    this.arrayCampos.push([
        {"xtype": 'combo', "store": storeSINO, "name": "d_comboNotificado", "fieldLabel": "Deudor notificado", allowBlank: false, "autoload": true, mode: 'local', triggerAction: 'all', resizable: true, id: 'd_comboNotificado' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
        ,{"xtype": 'datefield', "name": "d_fechaNotificacion", "fieldLabel": "Fecha notificación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    ]);

    //id: 382 : TRAMITE DE POSESIÓN (CAJAMAR): Suspensión lanzamiento
    this.arrayCampos.push([
        {"xtype":'datefield', "name":"d_fechaParalizacion", "fieldLabel":"Fecha paralización", allowBlank:false,  maxValue: (new Date().add(Date.MONTH,  2) ).format('d/m/Y'),  minValue: fechaMinima }
    ]);

    //id: 383 : TRAMITE DE POSESIÓN (CAJAMAR): H015_PresentarSolicitudSenyalamientoPosesion
    this.arrayCampos.push([
        {"xtype":'datefield',"name":"d_fechaSenyalamiento","fieldLabel":"Fecha señalamiento para posesión",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);

    // id: 384 : TRAMITE SUBASTA (CAJAMAR): H002_SenyalamientoSubasta
    this.arrayCampos.push([
        {"xtype":'numberfield', "name":"d_costasLetrado", "fieldLabel":"Costas de letrado", allowBlank:false,  filtrar: true}
        ,{"xtype":'datefield', "name":"d_fechaAnuncio", "fieldLabel":"Fecha anuncio", allowBlank:false,  maxValue: (new Date().add(Date.MONTH,  2) ).format('d/m/Y'),  minValue: fechaMinima }
        ,{"xtype":'numberfield', "name":"d_costasProcurador", "fieldLabel":"Costas del procurador", allowBlank:false}
        ,{"xtype":'datefield', "name":"d_fechaSenyalamiento", "fieldLabel":"Fecha de celebración", allowBlank:false,  maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);

    // id: 385 : TRAMITE SUBASTA (CAJAMAR): H002_RegistrarResSuspSubasta
    this.arrayCampos.push([
        {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha resolución", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype": 'combo', "store": storeSINO, "name": "d_comboSuspension", "fieldLabel": "Subasta suspendida", allowBlank: false, "autoload": true, mode: 'local', triggerAction: 'all', resizable: true, id: 'd_comboSuspension' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
    ]);

    // id: 386 : TRAMITE SUBASTA (CAJAMAR): H002_ConfirmarRecepcionMandamientoDePago
    this.arrayCampos.push([
        {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha recepción", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype": 'datefield', "name": "d_fechaEnvio", "fieldLabel": "Fecha envío", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype": 'numberfield', "name": "d_importe", "fieldLabel": "Importe", allowBlank: true}
    ]);

    // id: 387 : TRAMITE DE ADJUDICACION (CAJAMAR): H005_notificacionDecretoAdjudicacionAlContrario
    this.arrayCampos.push([
        {"xtype": 'combo', "store": storeSINO, "name": "d_comboNotificacion", "fieldLabel": "Notificado", allowBlank: false, "autoload": true, mode: 'local', triggerAction: 'all', resizable: true, id: 'd_comboNotificacion' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
        ,{"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    ]);

    // id: 388 : TRAMITE DE ADJUDICACION (CAJAMAR): H005_notificacionDecretoAdjudicacionAEntidad
    this.arrayCampos.push([
        {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha notificación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype": 'combo', "store": storeSINO, "name": "d_comboSubsanacion", "fieldLabel": "Requiere subsanación", "autoload": true,  mode: 'local', triggerAction: 'all', allowBlank: false, filtradoProcurador: true, resizable: true, id: 'd_comboSubsanacion' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
        ,{"xtype": 'combo', "store": storeSINO, "name": "d_comboAdicional", "fieldLabel": "Comunicación adicional requerida", "autoload": true,  mode: 'local', triggerAction: 'all', allowBlank: false, filtrar: true, resizable: true, id: 'd_comboAdicional' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
        ,{"xtype": 'datefield', "name": "d_fechaResol", "fieldLabel": "Fecha resolución", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype": 'datefield', "name": "d_fechaLimite", "fieldLabel": "Fecha límite comunicación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, filtrar: true}
    ]);

    // id: 389 : TRAMITE DE ADJUDICACION (CAJAMAR): H005_RegistrarInscripcionDelTitulo
    this.arrayCampos.push([
        {"xtype": 'combo', "store": this.storeDDSituacionTitulo, "name": "d_comboSituacionTitulo", "fieldLabel": "Título Inscrito en el Registro", "autoload": true,  mode: 'local', triggerAction: 'all', allowBlank: false, resizable: true, id: 'd_comboSituacionTitulo' + this.idFactoria, displayField: 'descripcion', valueField: 'codigo'}
        ,{"xtype": 'datefield', "name": "d_fechaInscripcion", "fieldLabel": "Fecha Inscripción", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype": 'datefield', "name": "d_fechaEnvioDecretoAdicion", "fieldLabel": "Fecha Envío Decreto Adición", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    ]);

    // id: 390 : T. CERTIFICADO DE CARGAS Y REVISIÓN (CAJAMAR): Registrar certificación
    this.arrayCampos.push([
        {"xtype": 'datefield', "name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false,  maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'),  minValue: fechaMinima }
    ]);

    // id: 391 : T. Ocupantes (CAJAMAR): H048_TrasladoDocuDeteccionOcupantes
    this.arrayCampos.push([
       {"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Bien ocupado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboDocumentacion","fieldLabel":"Documentación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboDocumentacion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
       ,{"xtype":'datefield',"name":"d_fechaDocumentos","fieldLabel":"Fecha documentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboInquilino","fieldLabel":"Existe algún inquilino",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboInquilino'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
       ,{"xtype":'datefield',"name":"d_fechaContrato","fieldLabel":"Fecha contrato arrendamiento",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       ,{"xtype":'textfield',"name":"d_nombreArrendatario","fieldLabel":"Nombre arrendatario",allowBlank:true,id:'d_nombreArrendatario'+this.idFactoria}
       ,{"xtype":'datefield',"name":"d_fechaVista","fieldLabel":"Fecha vista",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
       ,{"xtype":'datefield',"name":"d_fechaFinAle","fieldLabel":"Fecha fin alegaciones",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);

    // id: 392 : T. Ocupantes (CAJAMAR): H048_RegistrarCelebracionVista
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaResolucion", "fieldLabel": "Fecha de la vista", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);

    // id: 393 : T. Moratorio Posesion (CAJAMAR): H011_CelebracionVista
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaCelebracion", "fieldLabel": "Fecha celebración", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);

    // id: 394 : T. Cesión remate (CAJAMAR): H006_AperturaPlazo
    this.arrayCampos.push([
        {"xtype":'combo',"store":storeSINO,"name":"d_comboFinaliza","fieldLabel":"Realizada solicitud con facultad de cesión de remate",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFinaliza'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
        ,{"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'textfield',"name":"d_instrucciones","fieldLabel":"Instrucciones",allowBlank:true,id:'d_instrucciones'+this.idFactoria}
        ,{"xtype":'combo',"store":storeSINO,"name":"d_cbCresionRemate","fieldLabel":"Documentación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_cbCresionRemate'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
        ,{"xtype":'combo',"store":storeSINO,"name":"d_cbTitulizado","fieldLabel":"Documentación",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_cbTitulizado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
        ]);


    // id: 395 : T. Cesión remate (CAJAMAR): H006_ResenyarFechaComparecencia
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]); 
    
    // id: 396 : T. Cesión remate (CAJAMAR): H006_RealizacionCesionRemate
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 397 : T. Posesión interina (CAJAMAR): HC105_SolicitudPosesionInterina
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'combo',"store":storeSINO,"name":"d_comboOcupado","fieldLabel":"Ocupado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboOcupado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'} 
        ,{"xtype":'combo',"store":this.storeDDTipoBienCajamar,"name":"d_comboBien","fieldLabel":"Tipo de bien",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboBien'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
    ]);
    
    // id: 398 : T. Posesión interina (CAJAMAR): HC105_DecretoAdmision
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmision","fieldLabel":"Admisión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmision'+this.idFactoria,displayField:'descripcion',valueField:'codigo'} 
    ]);
    
    // id: 399 : T. Posesión interina (CAJAMAR): HC105_NotificacionOcupante
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha notificación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 400 : T. Posesión interina (CAJAMAR): HC105_RegistrarFechaPosesionInterina
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 401 : T. Posesión interina (CAJAMAR): HC105_RendicionCuentasSecretarioJudicial
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha escrito", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 402 : T. Posesión interina (CAJAMAR): HC105_AprobacionRendicionCuentas
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha escrito", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'} 
    ]);
    
    // id: 403 : T. Posesión interina (CAJAMAR): HC105_PresentacionRendicionCuentas
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha escrito", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'combo',"store":storeSINO,"name":"d_comboPosesion","fieldLabel":"Finaliza posesión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboPosesion'+this.idFactoria,displayField:'descripcion',valueField:'codigo'} 
    ]);
    
    // id: 404 : T. Posesión interina (CAJAMAR): HC105_RegistrarNotificacionRendicionCuentas
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha notificación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 405 : T. Posesión interina (CAJAMAR): HC105_RegistrarDisconformidadEjecutado
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha escrito", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'combo',"store":storeSINO,"name":"d_comboDisconformidad","fieldLabel":"Finaliza posesión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboDisconformidad'+this.idFactoria,displayField:'descripcion',valueField:'codigo'} 
    ]);
    
    // id: 406 : T. Posesión interina (CAJAMAR): HC105_AlegacionesDisconformidad
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha escrito", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAlegaciones","fieldLabel":"Finaliza posesión",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAlegaciones'+this.idFactoria,displayField:'descripcion',valueField:'codigo'} 
    ]);
    
    // id: 407 : T. Posesión interina (CAJAMAR): HC105_ConfirmaFechaVista
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha vista", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 408 : T. Posesión interina (CAJAMAR): HC105_CelebracionVista
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 409 : T. Posesión interina (CAJAMAR): HC105_RegistrarResolucion
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha escrito", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'combo',"store":this.storeDDPosesionInterinaResolucion,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
    ]);
    
    // id: 410 : T. Inscripción título (CAJAMAR): H066_registrarEntregaTitulo
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha recepción", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 411 : T. Inscripción título (CAJAMAR): H066_registrarPresentacionHacienda
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha presentación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 412 : T. Inscripción título (CAJAMAR): H066_registrarPresentacionRegistro
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaPresentacion", "fieldLabel": "Fecha presentación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'datefield',"name": "d_fechaTestimonio", "fieldLabel": "Fecha nuevo testimonio", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 413 : T. Inscripción título (CAJAMAR): H066_registrarInscripcionTitulo
    this.arrayCampos.push([
        {"xtype":'combo',"store":this.storeDDSituacionTitulo,"name":"d_situacionTitulo","fieldLabel":"Situación del título",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_situacionTitulo'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
        ,{"xtype":'datefield',"name": "d_fechaInscripcion", "fieldLabel": "Fecha inscripción", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
        ,{"xtype":'datefield',"name": "d_fechaEnvio", "fieldLabel": "Fecha envío escrito subsanación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 414 : T. mandamiento cancelación cargas (CAJAMAR): HC102_SolicitudMandamiento
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaSolicitud", "fieldLabel": "Fecha solicitud", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 415 : T. mandamiento cancelación cargas (CAJAMAR): HC102_ObtencionMandamientoCancelacionCargas
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaNotificacion", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 416 : T. mandamiento cancelación cargas (CAJAMAR): HC102_SolicitarArchivoProcedimiento
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaSolicitud", "fieldLabel": "Fecha solicitud", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 417 : T. mandamiento cancelación cargas (CAJAMAR): HC102_ResolucionFirme
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaComunicacion", "fieldLabel": "Fecha comunicación", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 418 : T. notificación demandados (CAJAMAR): P400_GestionarNotificaciones NotificacionEscritoSellado
    this.arrayCampos.push([
    ]);
    
    // id: 419 : T. notificación demandados (CAJAMAR): P400_GestionarNotificaciones NotificacionEscritoSelladoAveriguacion
    this.arrayCampos.push([
    ]);
    
    // id: 420 : T. notificación demandados (CAJAMAR): P400_GestionarNotificaciones NotificacionResolucionAcuerdaNotificacion
    this.arrayCampos.push([
    ]);
    
    // id: 421 : T. notificación demandados (CAJAMAR): P400_GestionarNotificaciones NotificacionResolucionAcuerdaAveriguacion
    this.arrayCampos.push([
    ]);
    
    // id: 422 : T. notificación demandados (CAJAMAR): P400_GestionarNotificaciones NotificacionDiligencia
    this.arrayCampos.push([
    ]);
    
    // id: 423 : T. notificación demandados (CAJAMAR): P400_GestionarNotificaciones NotificacionEscritoSelladoNotificacion
    this.arrayCampos.push([
    ]);
    
    // id: 424 : T. notificación demandados (CAJAMAR): P400_GestionarNotificaciones NotificacionDOAcordandoNotificacion
    this.arrayCampos.push([
    ]);
    
    // id: 425 : T. tributación bienes (CAJAMAR): H054_PresentarEscritoJuzgado
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fecha", "fieldLabel": "Fecha presentación escrito", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 426 : T. saneamiento cargas registrales (CAJAMAR): H008_RegistrarPresentacionInscripcion
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaPresentacion", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 427 : T. saneamiento cargas registrales (CAJAMAR): H008_RegInsCancelacionCargasReg
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaInscripcion", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 428 : T. saneamiento cargas registrales (CAJAMAR): H008_LiquidarCargas
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaCancelacion", "fieldLabel": "Fecha cancelación de las cargas", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 429 : T. saneamiento cargas registrales (CAJAMAR): H008_RegInsCancelacionCargasRegEco
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaInsReg", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 430 : T. saneamiento cargas registrales (CAJAMAR): H008_RegistrarPresentacionInscripcionEco
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaPresentacion", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 431 : T. saneamiento cargas registrales (CAJAMAR): H008_RegInsCancelacionCargasRegEco
    this.arrayCampos.push([
        {"xtype":'datefield',"name": "d_fechaInsReg", "fieldLabel": "Fecha", allowBlank: false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
    ]);
    
    // id: 432 : T. vigilancia y caducidad de embargos (CAJAMAR): H062_revisarRegistroEmbargo
    this.arrayCampos.push([
        {"xtype":'combo',"store":storeSINO,"name":"d_comboAlerta","fieldLabel":"Mantener alerta de seguridad",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAlerta'+this.idFactoria,displayField:'descripcion',valueField:'codigo'} 
    ]);
    
    //id: 433 : P. CAMBIARIO: Confirmar admision de la demanda (CAJAMAR): 
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",allowBlank:false,triggerAction: 'all',resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		},
		                      		 		select :function(combo){
		              							var idFactoria = combo.id.replace('d_comboPlaza','');
		              							var juzgado=Ext.getCmp('d_comboJuzgado' + idFactoria);
		              							var storeJuzgado= juzgado.getStore();
		              							storeJuzgado.load({params:{codigoPlaza:combo.getValue()}});
		            							storeJuzgado.on('load', function(){  
	                  								  var foundValue = false;
	                								  storeJuzgado.each(function(record)  
	                								  {
	                									  if(record.get("codigo") == juzgado.getValue()){
	                										  juzgado.setValue(juzgado.getValue());
	                										  foundValue = true;
	                									  }
	
	                								  }, this); 
	                								
	                								  if(!foundValue){
	                									  juzgado.setValue("");
	                								  }
		            							});
		              						}
		                      		 }
		                        }
		                     ,{"xtype":'combo',"editable":"false", "store":this.dsJuzgado, width:280,mode:'local', "name":"d_comboJuzgado","hiddenName":"d_comboJuzgado","fieldLabel":"Nº Juzgado",triggerAction: 'all',allowBlank:false, displayField:'descripcion',valueField:'codigo', id:'d_comboJuzgado' + this.idFactoria }
		                     ,{"xtype":'textfield',"name":"d_numProcedimiento","fieldLabel":"Nº de procedimiento",allowBlank:false, id:'d_numProcedimiento_id'+this.idFactoria
		         				,validator : function(v) {
		         						return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : "Debe introducir un n&uacute;mero con formato xxxxx/xxxx";
		         				}
		                      }
		                     ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAdmision","fieldLabel":"Admisión","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAdmision'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
		                     ,{"xtype":'combo',"store":storeSINO,"name":"d_comboBienes","fieldLabel":"Existen bienes registrables",allowBlank:false,filtradoProcurador:true, "autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboBienes'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 434 : T. EMBARGO DE SALARIOS: Solicitar la notificacion retención al pagador
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'numberfield',"name":"d_importeNom","fieldLabel":"Importe base retención",allowBlank:true}
	                       	,{"xtype":'numberfield',"name":"d_importeRet","fieldLabel":"Importe de retención",allowBlank:true}
	                      ]);
	
	//id: 435 : T. EMBARGO DE SALARIOS: Confirmar requerimiento de resultado
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":storeSINO,"name":"d_comboRequerido","fieldLabel":"Requerido",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboRequerido'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       	,{"xtype":'numberfield',"name":"d_importeNom","fieldLabel":"Importe base retención",allowBlank:true}
	                       	,{"xtype":'numberfield',"name":"d_importeRet","fieldLabel":"Importe de retención",allowBlank:true}
	                      ]);
	
	//id: 436 : T. EMBARGO DE SALARIOS: Confirmar retenciones practicadas
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDCorrectoCobro,"name":"d_comboCorr","fieldLabel":"Situación","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboCorr'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 437 : TRAMITE COSTAS : Autoaprobacion de costas
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_comboAprobada","fieldLabel":"Aprobada",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboAprobada'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                       ,{"xtype":'numberfield',"name":"d_cuantiaLetrado","fieldLabel":"Cuantía letrado",allowBlank:false,id:'d_cuantiaLetrado_id'}
						   ,{"xtype":'numberfield',"name":"d_cuantiaProcurador","fieldLabel":"Cuantía procurador",allowBlank:false,id:'d_cuantiaProcurador_id'}
	   				]);
	
	//id: 438 : TRAMITE COSTAS: Confirmar Notificacion H007_ConfirmarNotificacion
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":storeSINO,"value":"", "name":"d_comboResultado","fieldLabel":"Resultado notificación","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	                      ]);
	
	//id: 439 : P. CAMBIARIO: Interposicion de la demanda H016_interposicionDemandaMasBienes
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas, "name":"d_comboPlaza","hiddenName":"d_comboPlaza",fieldLabel:"Plaza del juzgado",triggerAction: 'all',allowBlank:false, resizable:true, id:'d_comboPlaza'+this.idFactoria
		                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
		                      		,listeners:{afterRender:function(combo){
		                      			 combo.mode='remote';
		                      		 		}
		                      		 }
		                     }
	                       ,{"xtype":'datefield',"name":"d_fechaCierre","fieldLabel":"Fecha cierre de la deuda",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                       ,{"xtype":'numberfield',"name":"d_capitalVencido","fieldLabel":"Capital vencido (en el cierre)",allowBlank:true,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesOrdinarios","fieldLabel":"Intereses Ordinarios (en el cierre)",allowBlank:true,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesDemora","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:true,filtrar:true}
	                       ,{"xtype":'combo',"store":storeSINO,"name":"d_provisionFondos","fieldLabel":"Solicitar provisión de fondos","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_provisionFondos'+this.idFactoria,displayField:'descripcion',valueField:'codigo',filtrar:true}
	                       ]);
	
	
	
	 // id: 440 : TRAMITE HIPOTECARIO : Demanda Sellada H001_DemandaCertificacionCargas
    this.arrayCampos.push([
     {"xtype":'datefield',"name":"d_fechaPresentacionDemanda","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
     ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
    	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
    		,listeners:{afterRender:function(combo){
    			 combo.mode='remote';
    		 		}
    		 }
      }
     ,{"xtype":'datefield',"name":"d_fechaCierreDeuda","fieldLabel":"Fecha cierre de la deuda",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, filtrar:true }
     ,{"xtype":'numberfield',"name":"d_principalDeLaDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
     ,{"xtype":'numberfield',"name":"d_capitalVencidoEnElCierre","fieldLabel":"Capital vencido (en el cierre)",allowBlank:false, filtrar:true}
     ,{"xtype":'numberfield',"name":"d_capitalNoVencidoEnElCierre","fieldLabel":"Capital no vencido (en el cierre)",allowBlank:false, filtrar:true}
     ,{"xtype":'numberfield',"name":"d_interesesOrdinariosEnElCierre","fieldLabel":"Intereses ordinarios (en el cierre)",allowBlank:false, filtrar:true}
     ,{"xtype":'numberfield',"name":"d_interesesDeDemoraEnElCierre","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:false, filtrar:true}
     ,{"xtype":'numberfield',"name":"d_respHipCap","fieldLabel":"Responsabilidad hipotecaria máxima por capital",allowBlank:false, filtrar:true}         
     ,{"xtype":'numberfield',"name":"d_respHipIntRem","fieldLabel":"Responsabilidad hipotecaria máxima por intereses remuneratorios",allowBlank:false, filtrar:true}
     ,{"xtype":'numberfield',"name":"d_respHipDem","fieldLabel":"Responsabilidad hipotecaria máxima por demora",allowBlank:false, filtrar:true}
     ,{"xtype":'numberfield',"name":"d_respHipCosGas","fieldLabel":"Responsabilidad hipotecaria máxima por costas y gastos",allowBlank:false, filtrar:true}
     ,{"xtype":'numberfield',"name":"d_creditoSupl","fieldLabel":"Credito supletorio",allowBlank:false, filtrar:true}      
     ,{"xtype":'combo',"store":storeSINO,"name":"d_provisionFondos","fieldLabel":"Provision Fondos","autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_provisionFondos'+this.idFactoria,displayField:'descripcion',valueField:'codigo',filtrar:true}         
     ]);

    //id: 441 : Trámite de Adjudicación - HCJ : Confirmar testimonio Decreto adjudicación H005_ConfirmarTestimonio
    this.arrayCampos.push([
        {"xtype":'datefield', "name":"d_fechaTestimonio", "fieldLabel":"Fecha Testimonio", allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype":'datefield', "name":"d_fechaNotificacion", "fieldLabel":"Fecha notificación testimonio", allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype":'combo', "store":storeSINO, "value":"",  "name":"d_comboSubsanacion", "fieldLabel":"Requiere Subsanación", id:'d_comboSubsanacion' + this.idFactoria, "autoload":true, mode:'local',triggerAction:'all', resizable:true, displayField:'descripcion', valueField:'codigo'}
        ,{"xtype":'combo', "store":storeSINO, "value":"",  "name":"d_comboAdicional", "fieldLabel":"Comunicación adicional requerida", id:'d_comboAdicional' + this.idFactoria, "autoload":true, mode:'local',triggerAction:'all', resizable:true, displayField:'descripcion', valueField:'codigo', filtrar:true}
        ,{"xtype":'datefield', "name":"d_fechaLimite", "fieldLabel":"Fecha límite comunicación", allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima, filtrar:true}
        ,{"xtype":'combo', "store":storeSINO, "value":"",  "name":"d_comboOcupantes", "fieldLabel":"Constancia de ocupantes", id:'d_comboOcupantes' + this.idFactoria, "autoload":true, mode:'local',triggerAction:'all', resizable:true, displayField:'descripcion', valueField:'codigo'}            
    ]);

    //id: 442 : Trámite de Adjudicación - HCJ : Registrar presentación en el registro H005_RegistrarPresentacionEnRegistro
    this.arrayCampos.push([
        {"xtype":'datefield', "name":"d_fechaPresentacion", "fieldLabel":"Fecha Presentación", allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
        ,{"xtype":'datefield', "name":"d_fechaNuevoTest", "fieldLabel":"Fecha nuevo testimoio", allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima}
    ]);
    
  //id: 443 : PROCEDIMIENTO MONITORIO: Interposición de la demanda
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaSolicitud","fieldLabel":"Fecha presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'combo',"store": this.dsPlazas,allowBlank:false, "name":"d_plazaJuzgado","hiddenName":"d_plazaJuzgado",fieldLabel:"Plaza del juzgado",triggerAction: 'all',resizable:true, id:'d_plazaJuzgado'+this.idFactoria
	                      	 ,displayField:'descripcion',valueField:'codigo',typeAhead: false,loadingText: 'Searching...',width: '300',resizable: true,pageSize: 10,	mode: 'local'
	                      		,listeners:{afterRender:function(combo){
	                      			 combo.mode='remote';
	                      		 		}
	                      		 }
	                        }
	                       ,{"xtype":'datefield',"name":"d_fechaCierre","fieldLabel":"Fecha cierre de la déuda",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_principalDemanda","fieldLabel":"Principal de la demanda",allowBlank:false}
	                       ,{"xtype":'numberfield',"name":"d_capitalVencido","fieldLabel":"Capital vencido (en el cierre)",allowBlank:false,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesOrdinarios","fieldLabel":"Intereses Ordinarios (en el cierre)",allowBlank:false,filtrar:true}
	                       ,{"xtype":'numberfield',"name":"d_interesesDemora","fieldLabel":"Intereses de demora (en el cierre)",allowBlank:false,filtrar:true}
	                       ,{"xtype":'combo', "store":storeSINO, "value":"",  "name":"d_provisionFondos", "fieldLabel":"Solicitar provisión de fondos", id:'d_provisionFondos' + this.idFactoria, "autoload":true, mode:'local',triggerAction:'all', resizable:true, displayField:'descripcion', valueField:'codigo', filtrar:true}
	                       ]);
	
	//id: 444 : TRAMITE COSTAS: Confirmar Notificacion H007_ConfirmarNotificacion
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":storeSINO,"value":"", "name":"d_comboResultado","fieldLabel":"Resultado notificación","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo',allowBlank:false}
	                      ]);
	
	//id: 445 : TRAMITE DE INTERESES: Registrar Vista
	this.arrayCampos.push([{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha vista",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }]);
	
	//id: 446 : TRAMITE DE INTERESES: Solicitar liquidación de intereses
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fechaRec","fieldLabel":"Fecha de recepción",allowBlank:false,filtrar:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'datefield',"name":"d_fechaPre","fieldLabel":"Fecha de presentación",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_intereses","fieldLabel":"Importe intereses",allowBlank:false}
	   				]);
	
	//id: 447 : TRAMITE DE INTERESES: Registrar resolucion
	this.arrayCampos.push([
	                       {"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       ,{"xtype":'numberfield',"name":"d_importe","fieldLabel":"Intereses",allowBlank:false}
	                       ,{"xtype":'combo',"store":this.storeDDFavorable,"name":"d_comboResultado","fieldLabel":"Resultado",allowBlank:false,filtradoProcurador:true,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
	   				]);
	
	//id: 448 : TRAMITE DE INTERESES: Confirmar Notificacion H042_ConfirmarNotificacion
	this.arrayCampos.push([
	                       	{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
	                       	,{"xtype":'combo',"store":this.storeDDPositivoNegativo,"value":"", "name":"d_comboResultado","fieldLabel":"Resultado notificación","autoload":true,	mode:'local',triggerAction:'all',resizable:true, id:'d_comboResultado'+this.idFactoria,displayField:'descripcion',valueField:'codigo',allowBlank:false}
	                      ]);

		var lengthArrayCampos = this.arrayCampos.length;
		for(var i=lengthArrayCampos; i<1000; i++){
			this.arrayCampos.push([]);
		}

		///ESPECIALES
		
		// id: 1000 : Subida de ficheros
        this.arrayCampos.push([
        ]);
        
        // id: 1001 : Autoprórroga
        this.arrayCampos.push([
                {"xtype":'datefield',"name":"d_fechaProrroga","fieldLabel":"Fecha Prórroga",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                ,{"xtype":'combo',"editable":"false","store":this.storeMotivosProrroga, width:'250', mode:'local', "name":"d_motivoProrroga","hiddenName":"d_motivoProrroga", id:'d_motivoProrroga_id' + this.idFactoria,"fieldLabel":"Motivo Pr&oacute;rroga",triggerAction: 'all',displayField:'descripcion',valueField:'codigo', "autoload":true }
        ]);

        // id: 1002 : Comunicación
        this.arrayCampos.push([
		        {"xtype":'combo',"store": ["Si", "No"], "name":"d_requiererespuesta","fieldLabel":"Requiere respuesta","autoload":true, mode:'local',triggerAction: 'all',resizable:true, id:'d_requiererespuesta'+this.idFactoria}
                ,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
                ,{"xtype":'textarea',"name":"d_texto","fieldLabel":"Texto",allowBlank:false,width:300}
        ]);
        
        // id : 1003 : Tarea
        this.arrayCampos.push([
			{"xtype":'textfield',"name":"d_asunto","fieldLabel":"Título del mensaje",allowBlank:false}
			,{"xtype":'combo',"store":storeSINO, "name":"d_comboFechaVencimiento","fieldLabel":"Hay fecha vencimiento",allowBlank:false,"autoload":true, mode:'local',triggerAction:'all',resizable:true, id:'d_comboFechaVencimiento'+this.idFactoria,displayField:'descripcion',valueField:'codigo'}
			,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de vencimiento",allowBlank:true, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima , id:'d_fecha'+this.idFactoria
				,validator : function(v) {
        	   		if(Ext.getCmp('d_comboFechaVencimiento' + idFactoria).getValue() == "01" && Ext.getCmp('d_fecha' + idFactoria).getValue() == ""){
        	   			return false;
        	   		}else{
        	   			return true;
        	   		}
				}	
			}
			,{"xtype":'textarea',"name":"d_mensaje","fieldLabel":"Mensaje",allowBlank:false,width:300}
        ]);
        
        // id : 1004 : Autotarea
        this.arrayCampos.push([
			{"xtype":'textfield',"name":"d_asunto","fieldLabel":"Título del mensaje",allowBlank:false}
			,{"xtype":'datefield',"name":"d_fecha","fieldLabel":"Fecha de vencimiento",allowBlank:false, maxValue: (new Date().add(Date.MONTH, 2) ).format('d/m/Y'), minValue: fechaMinima }
			,{"xtype":'textarea',"name":"d_mensaje","fieldLabel":"Mensaje",allowBlank:false,width:300}
        ]);
        
        // id : 1005 : Notificación
        this.arrayCampos.push([
			{"xtype":'textfield',"name":"d_asunto","fieldLabel":"Título del mensaje",allowBlank:false}
			,{"xtype":'textarea',"name":"d_mensaje","fieldLabel":"Mensaje",allowBlank:false,width:300}
        ]);
   
    }
	

});
