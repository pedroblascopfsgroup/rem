<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	var decisionId=${decisionProcedimiento.id != null ? decisionProcedimiento.id : 'null'};
	arrayProcedimientos=[];
	var procedimientoPadre='${idProcedimiento}';
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:160px';
	var labelStyle='font-weight:bolder;width:100';
	var labelStyleCombo='font-weight:bolder;width:150';
	var style='margin-bottom:1px;margin-top:1px';
	var errores="";

	var procedimientoRemoto = false;
	var modoConsulta=false;
	var faltaPermisos=false;
	var esSolicitud=true;
	<c:if test="${decisionProcedimiento!=null}" >
		if('${decisionProcedimiento.estadoDecision.codigo}' == '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_ACEPTADO" />'
			|| '${decisionProcedimiento.estadoDecision.codigo}' == '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_RECHAZADO" />' || (${isConsulta != null} && ${isConsulta}))
			modoConsulta=true;
	</c:if>
	<c:if test="${decisionProcedimiento!=null and empty decisionProcedimiento.procedimiento.processBPM and not empty decisionProcedimiento.procedimiento.guid}" >
	procedimientoRemoto = true;
	</c:if>
	
	var esGestor=${esGestor};
	var esSupervisor=${esSupervisor};
	var idProcedimiento = new Ext.form.Hidden({
		name:'idProcedimiento'
		<c:if test="${procedimiento!=null}" >
			,value:'${procedimiento.id}'
		</c:if>
	});
	
	<c:if test="${decisionProcedimiento!=null}" >
		if('${decisionProcedimiento.estadoDecision.codigo}' == '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_PROPUESTO" />' && ${!esSupervisor})			
			modoConsulta=true;
	</c:if>
	
	var estadoSegunPerfil;
	if(esGestor)
		estadoSegunPerfil= '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_PROPUESTO" />'
	if(esSupervisor)
		estadoSegunPerfil= '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_ACEPTADO" />'

	if(!esGestor && !esSupervisor) {
		modoConsulta = true;
		faltaPermisos = true;
	}
	
	var estadoDecision=new Ext.form.Hidden({
		name:'strEstadoDecision'
		,value: estadoSegunPerfil
	})
	//Tipo Actuacion
	var dictTipoActuacion = <app:dict value="${tiposActuacion}" />;
	
	var optionsTipoActuacionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : dictTipoActuacion
	       ,root: 'diccionario'
	});
	
	var tipoActuacion = new Ext.form.ComboBox({
	    name:'actuacion'
	    ,hiddenName:'actuacion'
	    ,store: optionsTipoActuacionStore
	    ,displayField:'descripcion'
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,emptyText:'----'
	    ,valueField: 'codigo'
		,width:250
		,labelStyle:labelStyleCombo
		,allowBlank:false
	    ,editable : false
		,fieldLabel : '<s:message code="procedimientos.edicion.tipoactuacion" text="**Tipo" />'
		<c:if test="${procedimiento!=null}" >
			,value:'${procedimiento.tipoActuacion.codigo}'
		</c:if>
	    //,value : 'actual'
	});
	
	tipoActuacion.on('select',function(){
		var codigo=tipoActuacion.getValue();
		optionsTipoProcedimientoStore.webflow({codigoTipoAct:codigo, prcId: '${idProcedimiento}'})
		comboTipoProcedimiento.reset();
	});
		
	
	var tipoProcedimientoRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
		,{name:'saldoMinimo'}
		,{name:'saldoMaximo'}
		,{name:'isUnicoBien'}
	]);

	var optionsTipoProcedimientoStore =	page.getStore({
	       flow: 'coreextension/getListTipoProcedimientosPorTipoActuacionByPropiedadAsunto'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'tiposProcedimiento'
	    }, tipoProcedimientoRecord)
	       
	});

	var comboTipoProcedimiento = new Ext.form.ComboBox({
				name:'tipoProcedimiento'
				<app:test id="tipoProcedimientoCombo" addComa="true" />
				,hiddenName:'tipoProcedimiento'
				,store:optionsTipoProcedimientoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,width:250
				,allowBlank:false
				,obligatory:true
				,resizable:true
				,triggerAction: 'all'
				,labelStyle:labelStyleCombo
				,editable: false
				,fieldLabel : '<s:message code="procedimientos.edicion.tipoprocedimiento" text="**Tipo Procedimiento" />'
	});

	if ('${procedimiento.tipoActuacion.codigo}' != '')
	{
		optionsTipoProcedimientoStore.load({
			params:{codigo:'${procedimiento.tipoActuacion.codigo}'}
			,callback: function()
			{
				if ('${procedimiento.tipoProcedimiento.codigo}' != '')
				{
					comboTipoProcedimiento.setValue('${procedimiento.tipoProcedimiento.codigo}');
				}
			}
		});
	}

	
	
	
	//Tipo Reclamacion
	var dictTipoReclamacion = <app:dict value="${tiposReclamacion}" />;
	
	//store generico de combo diccionario
	var optionsTipoReclamacionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoReclamacion
	});
	
	var comboTipoReclamacion = new Ext.form.ComboBox({
				name:'tipoReclamacion'
				,hiddenName:'tipoReclamacion'
				,store:optionsTipoReclamacionStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,allowBlank:false
				,width:250
				,triggerAction: 'all'
				,labelStyle:labelStyleCombo
				,editable: false
				,fieldLabel : '<s:message code="procedimientos.edicion.tiporeclamacion" text="**Tipo Reclamacion" />'
				<c:if test="${procedimiento!=null}" >
					,value:'${procedimiento.tipoReclamacion.codigo}'
				</c:if>
	});
	//Saldo a recuperar
	var saldoARecuperar = 
		app.creaNumber('saldorecuperar',
			'<s:message code="procedimientos.edicion.saldorecuperacion" text="**Saldo original " />',
			<c:if test="${procedimiento!=null}" >
				'${procedimiento.saldoRecuperacion}',
			</c:if>
			<c:if test="${procedimiento==null}" >
				'',
			</c:if>
			{labelStyle:labelStyleTextField
			,allowDecimals: true
			,allowBlank: false
			,allowNegative: false,maxLength:14}
	)
	
	//%recuperacion
	var recuperacion  = app.creaNumber('recuperacion',
		'<s:message code="procedimientos.edicion.recuperacion" text="**% Recuperacion " />',
		<c:if test="${procedimiento!=null}" >
				'${procedimiento.porcentajeRecuperacion}',
		</c:if>
		<c:if test="${procedimiento==null}" >
			'',
		</c:if>
		{labelStyle:labelStyleTextField
		,allowDecimals: true
		 ,allowBlank: false
		,allowNegative: false,maxLength:3}
	)
	//meses
	var meses = new Ext.form.NumberField({allowDecimals: false
		,name:'meses'
		,allowNegative: false
		,allowBlank: false
		,fieldLabel : '<s:message code="procedimientos.edicion.mesesrecuperacion" text="**Plazo (meses)" />'
		,labelStyle:labelStyleTextField
		,maxLength:2		
	});
	
	
	/** PROCEDIMIENTOS **/
	var procedimiento = Ext.data.Record.create([
			{name:"id"}
			,{name:"idProcedimiento"}
			,{name:"procedimientoPadre"}
			,{name:"descripcion"}
			,{name:"asunto"}
			,{name:"tipoActuacion"}
			,{name:"tipoReclamacion"}
			,{name:"tipoProcedimiento"}
			,{name:"porcentajeRecuperacion"}
			,{name:"plazoRecuperacion"}
			,{name:"saldoRecuperacion"}
			,{name:"personas"}

			
	]);
	procedimientoStore = page.getStore({event:'listado',flow : 'procedimiento/procedimientosDerivados',reader : new Ext.data.JsonReader({root:'listado'}, procedimiento)});//TODO:id falso, CAMBIAR!!!
	if('${decisionProcedimiento.id}'!='')
		procedimientoStore.webflow({id:decisionId});
	
	
	var transform=function(){
		var param={}
		var counterArray=-1;
		var counterPersonas=0;
		for(i=0;i < procedimientoStore.getCount();i++){	
			var rec=procedimientoStore.getAt(i);
			if(rec.get('tipoReclamacion')!=null){
				counterArray++;
				counterPersonas=0;
				param["procedimientosDerivados["+counterArray+"].id"]=rec.get('id');
				param["procedimientosDerivados["+counterArray+"].procedimientoPadre"]=rec.get('procedimientoPadre');
				param["procedimientosDerivados["+counterArray+"].tipoActuacion"]=rec.get('tipoActuacion');
				param["procedimientosDerivados["+counterArray+"].tipoReclamacion"]=rec.get('tipoReclamacion');
				param["procedimientosDerivados["+counterArray+"].tipoProcedimiento"]=rec.get('tipoProcedimiento');
				param["procedimientosDerivados["+counterArray+"].porcentajeRecuperacion"]=rec.get('porcentajeRecuperacion');
				param["procedimientosDerivados["+counterArray+"].plazoRecuperacion"]=rec.get('plazoRecuperacion');
				param["procedimientosDerivados["+counterArray+"].saldoRecuperacion"]=rec.get('saldoRecuperacion');
				param["procedimientosDerivados["+counterArray+"].personas["+counterPersonas+"]"]=rec.get('personas');
			}else{
				counterPersonas++;
				param["procedimientosDerivados["+counterArray+"].personas["+counterPersonas+"]"]=rec.get('personas');
			}
		}
		//agrego el valor combo de causas que no se porque motivo viaja mal en la request
		
		param["fechaParalizacionStr"] = fechaHasta.getValue();
		param["comentarios"] = comentarios.getValue();
		param["strEstadoDecision"] = estadoDecision.getValue();
		//param["causaDecision"]=comboCausas.getValue();
		param["causaDecisionFinalizar"]=comboCausasFinalizar.getValue();
		param["causaDecisionParalizar"]=comboCausasParalizar.getValue();
		
		
		param["finalizar"]=chkFinalizarOrigen.getValue();
		param["paralizar"]=chkParalizarOrigen.getValue();
		<%--param["fechaParalizacion"]=chkParalizarOrigen.getValue(); --%>
		return param;
	}
	
	
	var tipoActuacionRenderer=function(val){
		var arr=dictTipoActuacion.diccionario;
		for(i=0;i < arr.length;i++){
			if(arr[i].codigo==val)
				return arr[i].descripcion;
		}
		return val;
	};
	
	
	//Tipo Procedimiento
		var dictTipoProcedimiento = 
		<json:object>
			<json:array name="diccionario" items="${tiposProcedimientos}" var="d">	
			 <json:object>
			   <json:property name="codigo" value="${d.codigo}" />
			   <json:property name="descripcion" value="${d.descripcion}" />
			   <json:property name="saldoMinimo" value="${d.saldoMinimo}" />
			   <json:property name="saldoMaximo" value="${d.saldoMaximo}" />
			   <json:property name="isUnicoBien" value="${d.isUnicoBien}" />
			   <json:property name="codigoTipoActuacion" value="${d.tipoActuacion.codigo}" />
			 </json:object>
			</json:array>
	</json:object>;	
	
	var tipoReclamacionRenderer=function(val){
		var arr=dictTipoReclamacion.diccionario;
		for(i=0;i < arr.length;i++){
			if(arr[i].codigo==val)
				return arr[i].descripcion;
		}
		return val;
	};
	var tipoProcedimientoRenderer=function(val){
		var arr=dictTipoProcedimiento.diccionario;
		for(i=0;i < arr.length;i++){
			if(arr[i].codigo==val)
				return arr[i].descripcion;
		}
		return val;
	};
	var demandadosRenderer=function(val){
		var arr=personas.diccionario;
		for(i=0;i < arr.length;i++){
			if(arr[i].codigo==val)
				return arr[i].descripcion;
		}
		return val;
	}; 
	
	var procedimientoCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="decisionProcedimiento.grid.id" text="**id"/>', dataIndex : 'id',hidden:true}
		,{header : '<s:message code="decisionProcedimiento.grid.tipoActuacion" text="**tipoActuacion"/>', width : 100, dataIndex : 'tipoActuacion',renderer:tipoActuacionRenderer}
		,{header : '<s:message code="decisionProcedimiento.grid.tipoReclamacion" text="**tipoReclamacion"/>', width : 100, dataIndex : 'tipoReclamacion',renderer:tipoReclamacionRenderer}
		,{header : '<s:message code="decisionProcedimiento.grid.tipoProcedimiento" text="**tipoProcedimiento"/>', width : 200, dataIndex : 'tipoProcedimiento',renderer:tipoProcedimientoRenderer}
		,{header : '<s:message code="decisionProcedimiento.grid.porcentajeRecuperacion" text="**porcentajeRecuperacion"/>', width : 100, dataIndex : 'porcentajeRecuperacion'}
		,{header : '<s:message code="decisionProcedimiento.grid.plazoRecuperacion" text="**plazoRecuperacion"/>', width : 100, dataIndex : 'plazoRecuperacion'}
		,{header : '<s:message code="decisionProcedimiento.grid.saldoRecuperacion" text="**saldoRecuperacion"/>', width : 100, dataIndex : 'saldoRecuperacion'}
		,{header : '<s:message code="decisionProcedimiento.grid.personas" text="**personas"/>', width : 100, dataIndex : 'personas',renderer:demandadosRenderer}
	]);
	
	var titleFuncion = function(){
		if (esSupervisor && !modoConsulta){
			titleFuncion = '<s:message code="decisionProcedimiento.msg.actuaciones.editar" text="**Actuaciones (Pulse sobre la actuaci&oacute;n que quiera editar)" />';
		}else{
			titleFuncion = '<s:message code="decisionProcedimiento.grid.tituloClick" text="**Actuaciones" />';		
		}
		return titleFuncion;
	}
		
	var procedimientoGrid = new Ext.grid.GridPanel({
		store:procedimientoStore
		,cm:procedimientoCm
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,title:titleFuncion()
		,cls:'cursor_pointer'
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,iconCls:'icon_usuario'		
		,style:'padding-right:10px;'
		,width : 815
		,height:100
		,border:true
	});
	
		
	var resetTitle = function(){
		//var t = procedimientoGrid.title + ' [' + procedimientoGrid.store.getTotalCount() + ']';
		//procedimientoGrid.title = t;
	}
	
	//procedimientoStore.on('load', resetTitle());

	resetTitle();

	procedimientoGrid.on('rowclick',function(grid, rowIndex, e){
		if ((decisionId == null) || (modoConsulta)) return;
		if (!esSupervisor) return;
		var rec=procedimientoStore.getAt(rowIndex);
		var id=rec.get('idProcedimiento');
		Ext.Ajax.request({
				url: page.resolveUrl('plugin.mejoras.procedimientos.procedimientoData')
				,params: {id:id}
				,method: 'POST'
				,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText);
						limpiaDatosProcedimiento();
						muestraProcedimiento(r.procedimiento);
					}
			});
	});
	
	var limpiaDatosProcedimiento = function(){
		idProcedimiento.setValue('');
		comboTipoProcedimiento.setValue('');
		tipoActuacion.setValue('');
		comboTipoReclamacion.setValue('');
		saldoARecuperar.setValue('');
		recuperacion.setValue('');
		meses.setValue('');
		comboPersonas.reset();
	};
	
	var restaurarBotonera = function(){
		btnGuardarProcedimiento.hide();
		btnCancelGuardarProcedimiento.hide();
		btnEliminarProcedimiento.hide()
		btnAgregarProcedimiento.show();
	};
	
	var muestraProcedimiento = function (p){
		idProcedimiento.setValue(p.id);
		comboTipoProcedimiento.setValue(p.tipoProcedimiento.codigo);
		tipoActuacion.setValue(p.tipoActuacion.codigo);
		comboTipoReclamacion.setValue(p.tipoReclamacion.codigo);
		saldoARecuperar.setValue(p.saldoRecuperacion);
		recuperacion.setValue(p.porcentajeRecuperacion);
		meses.setValue(p.plazoRecuperacion);
		optionsTipoProcedimientoStore.load({
			params:{codigo:p.tipoActuacion.codigo, limit: 10, start: 0}});
			
		var demandados = '';
		for (var i=0;i < p.personasAfectadas.length; i++){
			if (demandados != '') demandados +=',';
			demandados += p.personasAfectadas[i].id;
		}
		comboPersonas.setValue(demandados);
		
		btnGuardarProcedimiento.show();
		btnCancelGuardarProcedimiento.show();
		btnEliminarProcedimiento.show();
		btnEliminarProcedimiento.setWidth(btnCancelGuardarProcedimiento.getWidth());
		btnAgregarProcedimiento.hide();
		comboTipoProcedimiento.setValue(p.tipoProcedimiento.codigo);
	};
	
	
	var personas = <json:object name="diccionario">
		<json:array name="diccionario" items="${personas}" var="per">
			<json:object>
				<json:property name="codigo" value="${per.id}"/>
				<json:property name="descripcion" value="${per.apellido1} , ${per.nombre}"/>
			</json:object> 
		</json:array>
	</json:object>
	
	var comboPersonas = app.creaDblSelect(personas, '<s:message code="decisionProcedimiento.demandados" text="**Demandados" />',{labelStyle:labelStyle,allowBlank:false});
		
	var validarDatos = function(saldoRec, permiteSinDemandados){
			errores = "";
			if(!tipoActuacion.validate())
				errores="<br><s:message code="decisionProcedimiento.validacion.tipoActuacion" text="**Validar tipo actuacion"/>";
			
			if(!comboTipoReclamacion.validate())
				errores+="<br><s:message code="decisionProcedimiento.validacion.tipoReclamacion" text="**Validar tipo reclamaci\F3n"/>";
			
			if(!comboTipoProcedimiento.validate())
				errores+="<br><s:message code="decisionProcedimiento.validacion.tipoProcedimiento" text="**Validar tipo procedimiento"/>";
			else{
				//Validacion Saldos
				var index = comboTipoProcedimiento.selectedIndex;
				if(index>=0 && saldoARecuperar.validate()){
					var record = optionsTipoProcedimientoStore.getAt( index );
					var saldoMinimo	= record.get('saldoMinimo');
					var saldoMaximo	= record.get('saldoMaximo');
					
					if(saldoMinimo && saldoRec < saldoMinimo){
						errores+="<br><s:message code="decisionProcedimiento.validacion.saldoMinimo" text="**Validar saldo m\EDmino"/> "+saldoMinimo;
					}
					if(saldoMaximo && saldoRec > saldoMaximo){
						errores+="<br><s:message code="decisionProcedimiento.validacion.saldoMaximo" text="***Validar saldo m\E1ximo"/> "+saldoMaximo;
					}
				}
			}
			//var saldoRec=saldoARecuperar.getValue();
			if(!saldoARecuperar.validate())
				errores+="<br><s:message code="decisionProcedimiento.validacion.saldoARecuperar" text="**Validar saldo a recuperar"/>";			
			if(!recuperacion.validate())
				errores+="<br><s:message code="decisionProcedimiento.validacion.recuperacion" text="**Validar recuperaci�n"/>";
			if(!meses.validate())
				errores+="<br><s:message code="decisionProcedimiento.validacion.plazo" text="**Validar plazo"/>";
				
			var demandados=comboPersonas.getValue();
			if(demandados=='' && !permiteSinDemandados) {
				errores+="<br><s:message code="decisionProcedimiento.validacion.demandados" text="**Validar demandados"/>";							
			}
			if(errores!=""){
				Ext.Msg.alert("Errores",errores);
				return false;
			}else{
				return true;
			}
			
	};	
	
	var activarComprobacionSubasta = false;
	var mensaje = false;
	
	var comprobarSubasta = function(){
		var tipoActuacion =  comboTipoProcedimiento.getValue();	
		if(tipoActuacion == 'P401' || tipoActuacion == 'P409' 
			|| tipoActuacion == 'H002' || tipoActuacion == 'H003' || tipoActuacion == 'H004'){
			activarComprobacionSubasta = true;
			Ext.Ajax.request({
				url: page.resolveUrl('decisionprocedimiento/esTramiteSubastaByPrcId')
				,params: {prcId:'${idProcedimiento}'}
				,method: 'POST'
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText);
					mensaje = r.esTramiteSubasta;
				}
			});
		}
	} 
	
	
	
	
	var addProcedimiento = function(permiteSinDemandados) {
	
		var tipoActu=tipoActuacion.getValue();
		var tipoRec=comboTipoReclamacion.getValue();
		var tipoProc=comboTipoProcedimiento.getValue();
		var recup=recuperacion.getValue();
		var nroMeses=meses.getValue();
		var saldoRec=saldoARecuperar.getValue();
		var demandados=comboPersonas.getValue();
		var demandados=comboPersonas.getValue();
		
			
		if(validarDatos(saldoRec, permiteSinDemandados)){
			var idx;
			var arrayDemandados=demandados.split(',');
			for(idx=0;idx < arrayDemandados.length;idx++){
				var rec;
				var demandado=arrayDemandados[idx];
				if(idx==0){
					rec={
						procedimientoPadre:procedimientoPadre
						,tipoActuacion:tipoActu
						,tipoReclamacion:tipoRec
						,tipoProcedimiento:tipoProc
						,porcentajeRecuperacion:recup
						,plazoRecuperacion:nroMeses
						,saldoRecuperacion:saldoRec
						,personas:demandado
					};
				}	
				else{
					rec={personas:demandado};					
				}
				procedimientoStore.add(new Ext.data.Record(rec));
				
				comprobarSubasta();
			}			
		}
	};
	
	var compruebaUnicoBien = function(funcion) {
		//Comprueba en caso de no haber introducido demandados que el procedimiento tenga marcado el flag unicoBien, 
		// si es as�, se le permitir� agregar la decisi�n sin demandados.
		
		var demandados=comboPersonas.getValue();
		if(demandados=='') {
			var unicoBien = false;
						
			var index = comboTipoProcedimiento.selectedIndex;
			if(index>=0){
				var record = optionsTipoProcedimientoStore.getAt( index );
				unicoBien = record.get("isUnicoBien") || false;			
			}
			
			if (unicoBien) {
				//Si el tipo de procedimiento tiene marcado el flag unico bien, se le permite que no tenga demandados
				Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="decisionProcedimiento.validacion.sinDemandados" text="**No se ha a�adido ning�n demandado �Desea continuar?" />', function(btn){
    				if (btn == 'yes'){
    					if (funcion == 'addProcedimiento') {
    						addProcedimiento(true);
    					} else {
    						guardarProcedimiento(true);
    					}
    				}
				});
			} else {			
				if (funcion == 'addProcedimiento') {
					addProcedimiento(false);
				} else {
					guardarProcedimiento(false);
				}
			}			
		} else {			
			if (funcion == 'addProcedimiento') {
				addProcedimiento(false);
			} else {
				guardarProcedimiento(false);
			}
		}
	};
	
	var btnAgregarProcedimiento = new Ext.Button({
		text : '<s:message code="app.agregar" text="**Agregar" />'
		,iconCls : 'icon_mas'
		,hidden: (!esSupervisor) && (decisionId != null)
		,handler : function(){
			compruebaUnicoBien('addProcedimiento');
		}
	});
	
	
	var btnCancelGuardarProcedimiento = new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,hidden:true
		,handler : function(){
			limpiaDatosProcedimiento();
			restaurarBotonera();
		}
	});
	
	var guardarProcedimiento = function(permiteSinDemandados) {
		var tipoActu=tipoActuacion.getValue();
		var tipoRec=comboTipoReclamacion.getValue();
		var tipoProc=comboTipoProcedimiento.getValue();
		var recup=recuperacion.getValue();
		var nroMeses=meses.getValue();
		var saldoRec=saldoARecuperar.getValue();
		var demandados=comboPersonas.getValue();
	
		if (validarDatos(saldoRec, permiteSinDemandados)) {
			var parametros = {id:decisionId};
			parametros.idProcedimiento = idProcedimiento.getValue();
			parametros.tipoActuacion = tipoActu;
			parametros.tipoReclamacion = tipoRec;
			parametros.tipoProcedimiento = tipoProc;
			parametros.porcentajeRecuperacion = recup;
			parametros.plazoRecuperacion = nroMeses;
			parametros.saldoRecuperacion = saldoRec;
			parametros.personas = demandados;
	
			Ext.Ajax.request({
				url: page.resolveUrl('plugin.mejoras.procedimientos.guardarProcedimientoDecision')
				,params: parametros
				,method: 'POST'
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText);
						limpiaDatosProcedimiento();
						restaurarBotonera();
						procedimientoStore.webflow({id:decisionId});
					}
			});	
		}
	};
	
	var btnGuardarProcedimiento = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_aplicar'
		,hidden:true
		,handler : function(){
			compruebaUnicoBien('guardarProcedimiento');
		}
	});
	
	var btnEliminarProcedimiento = new Ext.Button({
		text : '<s:message code="app.borrar" text="**Borrar" />'
		,iconCls : 'icon_asunto_rechazar'
		,hidden:true
		,handler : function(){
			<%--if (procedimientoGrid.store.getTotalCount() <= 1){
				Ext.Msg.alert('<s:message code="decisionProcedimiento.eliminarActuacion" text="**Eliminar actuacion" />','<s:message code="decisionProcedimiento.eliminarActuacion.error.gridVacio" text="**Sin actuaciones" />');
				return;
			} --%>
			Ext.Msg.show({
   				title:'<s:message code="decisionProcedimiento.eliminarActuacion" text="**Eliminar actuacion" />',
   				msg: '<s:message code="decisionProcedimiento.eliminarActuacion.confirmar" text="**\BFEst\E1 seguro de borrar?" />',
   				buttons: Ext.Msg.YESNO,
   				fn: function(btn,text){
   					if (btn == 'yes'){
   						var parametros = {id:decisionId};
						parametros.idProcedimiento = idProcedimiento.getValue();
   						Ext.Ajax.request({
							url: page.resolveUrl('plugin.mejoras.procedimientos.eliminarProcedimientoDecision')
							,params: parametros
							,method: 'POST'
							,success: function (result, request){
									var r = Ext.util.JSON.decode(result.responseText);
									limpiaDatosProcedimiento();
									restaurarBotonera();
									procedimientoStore.webflow({id:decisionId});
								}
						});
   					}
   				}
			});
		}
	});
	
	//Panel Inferior
	
	
	var chkFinalizarOrigen, chkParalizarOrigen;

	var comprobarPermitidoAceptar = false;

	chkFinalizarOrigen=new Ext.form.Checkbox({
		boxLabel :'<b><s:message code="decisionProcedimiento.finalizarorigen" text="**Finalizar origen" /></b>'
		,labelSeparator: ''
		,name:'chkFinalizarOrigen'
		,handler:function(){
			//comboCausas.setDisabled(!comboCausas.disabled);
			//if(comboCausas.disabled) fechaHasta.setDisabled(true);
			
			comboCausasFinalizar.setDisabled(!comboCausasFinalizar.disabled);
			comboCausasParalizar.setDisabled(comboCausasParalizar.disabled);									
			if ( (comboCausasFinalizar.disabled) && (comboCausasParalizar.disabled) ) 
			{
				fechaHasta.setDisabled(true);				
				comboCausasParalizar.setVisible(false);
				comboCausasFinalizar.setVisible(true);
			}
				
				
		}
		,readOnly:modoConsulta
		,disabled:modoConsulta
		<c:if test="${decisionProcedimiento.finalizada}">
			,checked:true
		</c:if>
		
	});


	chkFinalizarOrigen.on('check', function(checkbox, isCheck){
			chkParalizarOrigen.setValue(false);
			checkbox.setValue(isCheck);
			if (isCheck){
				if (comprobarPermitidoAceptar){
					btnAceptarPropuesta.disable();
					habilitarBotonProponer();
				}
			}else if (comprobarPermitidoAceptar){
					btnAceptarPropuesta.enable();
					btnProponer.disable();
			}
			if (!isCheck && !chkParalizarOrigen.getValue())
			{
				//comboCausas.clearValue();
				comboCausasFinalizar.clearValue();
			}
			
			if (isCheck){
				comboCausasParalizar.setVisible(false);
				comboCausasFinalizar.setVisible(true);
				comboCausasFinalizar.allowBlank = false;
			}
			else{
				comboCausasParalizar.setVisible(true);
				comboCausasFinalizar.setVisible(false);
				comboCausasFinalizar.allowBlank = true;
			}			
			
	}); 
	
	

	chkParalizarOrigen=new Ext.form.Checkbox({
		boxLabel:'<b><s:message code="decisionProcedimiento.paralizarorigen" text="**Paralizar origen" /></b>'
		,name:'chkParalizarOrigen'
		,labelSeparator: ''
		,handler:function(){
			//comboCausas.setDisabled(!comboCausas.disabled);
			//if(comboCausas.disabled) fechaHasta.setDisabled(true);
			
			comboCausasFinalizar.setDisabled(comboCausasFinalizar.disabled);
			comboCausasParalizar.setDisabled(!comboCausasParalizar.disabled);			
			if ( (comboCausasFinalizar.disabled) && (comboCausasParalizar.disabled) ){ 
				fechaHasta.setDisabled(true);
			}			
			
		}
		,readOnly:modoConsulta
		,disabled:modoConsulta
		<c:if test="${decisionProcedimiento.paralizada}">
			,checked:true
		</c:if>
		
	});

	chkParalizarOrigen.on('check', function(checkbox, isCheck){
			chkFinalizarOrigen.setValue(false);
			checkbox.setValue(isCheck);

			if (isCheck){
				if (comprobarPermitidoAceptar){
					btnAceptarPropuesta.disable();
					habilitarBotonProponer();				
				}	
			}else if (comprobarPermitidoAceptar){
					btnAceptarPropuesta.enable();
					btnProponer.disable();
			}
			if (!isCheck && !chkParalizarOrigen.getValue())
			{
				//comboCausas.clearValue();
				comboCausasParalizar.clearValue();
			}
			
			if (isCheck){
				comboCausasParalizar.setVisible(true);
				comboCausasFinalizar.setVisible(false);
				comboCausasParalizar.allowBlank = false;
				fechaHasta.setDisabled(false);
				fechaHasta.allowBlank = false;
			}
			else{
				comboCausasParalizar.setVisible(false);
				comboCausasFinalizar.setVisible(true);
				comboCausasParalizar.allowBlank = true;
				fechaHasta.setDisabled(true);
				fechaHasta.allowBlank = true;
			}			
			
	}); 




	var dictCausasFinalizar = <app:dict value="${causaDecisionFinalizar}" />
	var dictCausasParalizar = <app:dict value="${causaDecisionParalizar}" />
	
	//store generico de combo diccionario
	
	/*
	var optionsCausasStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictCausas
	});
	
	var comboCausas = new Ext.form.ComboBox({
				store:optionsCausasStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,name:'causa'
				,disabled: true && (!chkFinalizarOrigen.checked && !chkParalizarOrigen.checked)
				,mode: 'local'
				,editable:false
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,value:'${decisionProcedimiento.causaDecision.codigo}'
				,disabled:modoConsulta
				,fieldLabel : '<s:message code="decisionProcedimiento.causas" text="**Causas" />'
	});
	*/
	
	var optionsCausasStoreFinalizar = new Ext.data.JsonStore({fields: ['codigo', 'descripcion'],root: 'diccionario',data : dictCausasFinalizar});
	var optionsCausasStoreParalizar = new Ext.data.JsonStore({fields: ['codigo', 'descripcion'],root: 'diccionario',data : dictCausasParalizar});
	
	var comboCausasFinalizar = new Ext.form.ComboBox({store:optionsCausasStoreFinalizar,displayField:'descripcion',valueField:'codigo',name:'causa',disabled: (true && !chkFinalizarOrigen.checked) || modoConsulta,mode: 'local',editable:false,triggerAction: 'all',labelStyle:labelStyle,value:'${decisionProcedimiento.causaDecisionFinalizar.codigo}',fieldLabel : '<s:message code="decisionProcedimiento.causasFinalizar" text="Causa" />'});
	var comboCausasParalizar = new Ext.form.ComboBox({store:optionsCausasStoreParalizar,displayField:'descripcion',valueField:'codigo',name:'causa',disabled: (true && !chkParalizarOrigen.checked) || modoConsulta,mode: 'local',editable:false,triggerAction: 'all',labelStyle:labelStyle,value:'${decisionProcedimiento.causaDecisionParalizar.codigo}',fieldLabel : '<s:message code="decisionProcedimiento.causasParalizar" text="Causa" />'});
	
	if ( (!chkFinalizarOrigen.checked) && (!chkParalizarOrigen.checked) ){
		comboCausasParalizar.setVisible(false);
		comboCausasFinalizar.setVisible(true);
	}
	else if ( (chkFinalizarOrigen.checked) && (!chkParalizarOrigen.checked) ){		
		comboCausasParalizar.setVisible(false);
		comboCausasFinalizar.setVisible(true);	
	}
	else if ( (!chkFinalizarOrigen.checked) && (chkParalizarOrigen.checked) ){		
		comboCausasParalizar.setVisible(true);
		comboCausasFinalizar.setVisible(false);	
	}	
	
	
	var hoy = new Date();
	
	var fechaHasta=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="decisionProcedimiento.fechahasta" text="**Hasta" />'
		,labelStyle:labelStyle
		,disabled: modoConsulta || ${decisionProcedimiento.finalizada == null || (decisionProcedimiento.finalizada != null && decisionProcedimiento.finalizada)} 
		,name:'fechaParalizacion'
		,minValue : hoy
		,value:	'<fwk:date value="${decisionProcedimiento.fechaParalizacion}" />'			
	});
	var comentarios=new Ext.form.TextArea({
		fieldLabel : '<s:message code="decisionProcedimiento.comentarios" text="**Comentarios" />'
		,width:200
		,height:60
		,maxLength:4000
		,labelStyle:labelStyle
		,readOnly:modoConsulta
		,name:'comentarios'
		,value:'<s:message text="${decisionProcedimiento.comentarios}" javaScriptEscape="true" />'
		
	});
	
	var btnAceptarPropuesta = new Ext.Button({
		text : '<s:message code="decisionProcedimiento.aceptarpropuesta" text="**Aceptar Propuesta" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			errores = "";
			if (validarDatosFormulario()){	
				if(activarComprobacionSubasta && mensaje && !chkFinalizarOrigen.getValue()){
					Ext.Msg.show({
					   title:'Confirmaci�n',
					   msg: '�Est� seguro de no querer finalizar la subasta en curso? En caso de continuar ambas subastas se encontrar�n activas.',
					   buttons: Ext.Msg.YESNO,
					   animEl: 'elId',
					   width:450,
					   fn: processResult,
					   icon: Ext.MessageBox.QUESTION
					});
				}
				else{
					var params = transform();
					params["idProcedimiento"]='${idProcedimiento}';
					params["idDecision"]=decisionId;
					page.webflow({
						flow: 'decisionprocedimiento/aceptarPropuesta'
						,params: params
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});
				}
			}
			else{
				btnAceptarPropuesta.enable();
			}
		}
	});
	
	btnAceptarPropuesta.on('click',function(){
		btnAceptarPropuesta.disable();
	})
	
	
	function processResult(opt){
	   if(opt == 'no'){
	   		btnAceptarPropuesta.enable();
	      //page.fireEvent(app.event.CANCEL);
	   }
	   if(opt == 'yes'){
			var params = transform();
			params["idProcedimiento"]='${idProcedimiento}';
			params["idDecision"]=decisionId;
			page.webflow({
				flow: 'decisionprocedimiento/aceptarPropuesta'
				,params: params
				,success : function(){ 
					page.fireEvent(app.event.DONE); 
				}
			});
	   }
	}
	
	function habilitarBotonProponer() {
		if(!procedimientoRemoto) {
			btnProponer.enable();
		}
	}
	
	var validarDatosFormulario = function(){
	
		var saldoRec=saldoARecuperar.getValue();
		if (chkFinalizarOrigen.getValue()){
			if(comboCausasFinalizar.getValue()){
				return true;
			}else{
				Ext.Msg.alert('<s:message code="app.error" text="**Error" />', '<s:message code="decisionProcedimiento.errores.causaNula" text="**Debe seleccionar una causa para la decisi�n." />');
			}
		} else if(chkParalizarOrigen.getValue()){
			if(comboCausasParalizar.getValue()){
				if(fechaHasta.getValue()){
					return true;
				}else{
					Ext.Msg.alert('<s:message code="app.error" text="**Error" />', '<s:message code="decisionProcedimiento.errores.fechaNula" text="**Debe seleccionar una fecha de fin de paralizaci�n." />');
				}
			}else{
				Ext.Msg.alert('<s:message code="app.error" text="**Error" />', '<s:message code="decisionProcedimiento.errores.causaNula" text="**Debe seleccionar una causa para la decisi�n." />');
			}
		} else if(procedimientoStore.getCount() >= 1){
			return true;
		} else {
			btnAceptarPropuesta.enable();
			return false;
		}
		return false;
	}

	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			//page.submit({
			//	eventName : 'cancel'
			//	,formPanel : panelEdicion
			//	,success : function(){ page.fireEvent(app.event.CANCEL); } 	
			//});
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var btnProponer=new Ext.Button({
		text : '<s:message code="decisionProcedimiento.proponer" text="**Proponer" />'
		,iconCls:'icon_elevar'
		,handler : function(){
			if (validarDatosFormulario()){
				var params = transform();
				params["idProcedimiento"]='${idProcedimiento}';
				params["idDecision"]='${id}';
				page.webflow({
					flow: 'decisionprocedimiento/crearPropuesta'
					,params: params
					,success : function(){ 
						page.fireEvent(app.event.DONE); 
					}
				});
			}
			else{
				habilitarBotonProponer();
			}
		}
	});
	
	btnProponer.on('click',function(){
		btnProponer.disable();
	})
	
	
	var btnRechazar=new Ext.Button({
		text:'<s:message code="decisionProcedimiento.rechazar" text="**Rechazar" />'
		,iconCls:'icon_rechazar_decision'
		,handler : function(){

			page.webflow({
				flow: 'decisionprocedimiento/rechazarPropuesta'
				,params: {idDecision:decisionId}
				,success : function(){ 
					page.fireEvent(app.event.DONE); 
				}
			});
	     }
	});

	var panelSuperior={
			title:'<s:message code="decisionProcedimiento.panelprocedimientos" text="**Actuaciones Derivadas" />'			
			,layout:'table'
			//,width:870
			,layoutConfig:{
				columns:3
			}
			,defaults:{xtype:'fieldset',cellCls : 'vtop', autoHeight:true}
			,style:'padding:2px;cellspacing:2px'
			,items:[
				{
					//autoHeight:true
					height:160
					,xtype:'fieldset'
					,style:'padding:5px'
					,title:'<s:message code="procedimientos.edicion.tipoactuacion" text="**Tipo Actuacion" />'
					,width:440
					//,border:false
					,hidden:modoConsulta
					,items:[tipoActuacion,comboTipoProcedimiento,comboTipoReclamacion]
				},{border:false,html:'&nbsp;',width:20},{
					//autoHeight:true
					height:160
					//,colspan:2
					,xtype:'fieldset'
					,style:'padding:5px;cellspacing:5px'
					,title:'<s:message code="procedimientos.edicion.estimacion" text="**Estimacion" />'
					,width:320
					,hidden:modoConsulta
					//,border:false
					,items:[saldoARecuperar,recuperacion,meses]
				},{
					colspan:2
					,autoHeight:true
					,width:450
					,hidden:modoConsulta
					,border:false
					,items:comboPersonas
				},
				{
					layout:'table'
					,layoutConfig:{
						columns:4
					},
					items:[btnAgregarProcedimiento,btnGuardarProcedimiento,btnEliminarProcedimiento,btnCancelGuardarProcedimiento]
					,width:350
					,autoHeight:true
					,border:false
					,hidden:modoConsulta
				},				
				{
					colspan:3
					,width:830
					,height:100
					,border:false
					,items:[
						<%--{
							html:'<s:message text="**Doble click para editar"  code="decisionProcedimiento.msg.editarActuaciones"/>'
							,border: false
							,style:'font-weight:bolder;font-size:0.6em;color:#00008B'
							,hidden:(decisionId=='' || modoConsulta)
						}
						, --%>
						new Ext.form.Label({
							text:'<s:message code="decisionProcedimiento.msg.actuaciones.noeditar" text="**La decisi�n est� aceptada/cancelada y no se puede editar" />'
							,style:'margin:10px;font-size:13pt;font-family:Arial; color:#FF0000'
							,hidden: faltaPermisos || !modoConsulta || '${decisionProcedimiento.estadoDecision.codigo}' == '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_PROPUESTO" />'
							})
						,
						new Ext.form.Label({
							text:'<s:message code="decisionProcedimiento.msg.actuaciones.noeditar.propuesto" text="**La decisi�n est� propuesta y no se puede editar" />'
							,style:'margin:10px;font-size:13pt;font-family:Arial; color:#FF0000'
							,hidden: faltaPermisos || !modoConsulta || '${decisionProcedimiento.estadoDecision.codigo}' != '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_PROPUESTO" />'
							})
						,
						new Ext.form.Label({
							text:'<s:message code="decisionProcedimiento.msg.actuaciones.no.permisos" text="**No tiene permisos de usuario" />'
							,style:'margin:10px;font-size:13pt;font-family:Arial; color:#FF0000'
							,hidden: !faltaPermisos
							})
						, procedimientoGrid
					]
				}

				
			]
	};
	var bbar = []

	if(!modoConsulta){		
		bbar.push(btnAceptarPropuesta);
		if(esSupervisor){					
			if (decisionId != null)
				bbar.push(btnRechazar);
		}else {
			if (decisionId == null){
				bbar.push(btnProponer);
				btnProponer.disable();
				comprobarPermitidoAceptar = true;
			}
		}
	}
	
	bbar.push(btnCancelar);
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight:true
		, border : false
				,layout : 'column'
				,height: 155
				,defaults:{xtype:'fieldset',cellCls : 'vtop',width:860, height:100}
				,items:[{
					title:'<s:message code="decisionProcedimiento.paneldecision" text="**Finalizar/Parar Origen" />'
					,layout:'table'
					,layoutConfig:{
						columns:3							
					}
					,defaults:{layout : 'form',border:false,height:75}
					,items:[
						{
						items:[{
							border:false
							,style:'font-size:11px; margin:4px; top:5px'
							, bodyStyle:'padding:5px'
							,items:[
								chkFinalizarOrigen
								,chkParalizarOrigen
							]}]
						, width: 200
						}
						,{
							items:[comboCausasFinalizar,comboCausasParalizar,estadoDecision, fechaHasta]
							,width:280
						}
						,{
							items:comentarios
							,width:340
						}
					]
				}]
	});

	var panel=new Ext.Panel({
		border:false
		,bodyStyle : 'padding:5px'
		,autoHeight:true
		,autoScroll:true
		,width:840
		,height:600
		,defaults:{xtype:'fieldset',cellCls : 'vtop',width:840,autoHeight:true}
		,items:[panelSuperior,panelEdicion]
		,bbar:bbar
	})
	page.add(panel);
	
</fwk:page>