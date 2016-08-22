<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var decisionId='${decisionProcedimiento.id}'
	arrayProcedimientos=[];
	var procedimientoPadre='${idProcedimiento}'
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:160px'
	var labelStyle='font-weight:bolder;width:100';
	var labelStyleCombo='font-weight:bolder;width:150';
	var style='margin-bottom:1px;margin-top:1px';
	
	var modoConsulta=false;
	var esSolicitud=true;
	<c:if test="${decisionProcedimiento!=null}" >
		if('${decisionProcedimiento.estadoDecision.codigo}' == '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_ACEPTADO" />'
			||'${decisionProcedimiento.estadoDecision.codigo}' == '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_RECHAZADO" />' || (${isConsulta != null} && ${isConsulta}))
			modoConsulta=true;
	</c:if>

	var esGestor=${esGestor};
	var esSupervisor=${esSupervisor};
	var idProcedimiento = new Ext.form.Hidden({
		name:'idProcedimiento'
		<c:if test="${procedimiento!=null}" >
			,value:'${procedimiento.id}'
		</c:if>
	});
	var estadoSegunPerfil;
	if(esGestor)
		estadoSegunPerfil= '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_PROPUESTO" />'
	if(esSupervisor)
		estadoSegunPerfil= '<fwk:const value="es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision.ESTADO_ACEPTADO" />'
		
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
	    ,obligatory: true
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
		optionsTipoProcedimientoStore.webflow({codigo:codigo})
		comboTipoProcedimiento.reset();
	});
		
	
	var tipoProcedimientoRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
		,{name:'saldoMinimo'}
		,{name:'saldoMaximo'}
	]);
	var optionsTipoProcedimientoStore =	page.getStore({
	       flow: 'procedimientos/buscarTiposProcedimiento'
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
				,resizable:true
				,triggerAction: 'all'
				,labelStyle:labelStyleCombo
				,editable: false
				,fieldLabel : '<s:message code="procedimientos.edicion.tipoprocedimiento" text="**Tipo Procedimiento" />'
				,allowBlank: false
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
		param["causaDecision"]=comboCausas.getValue();
		param["finalizar"]=chkFinalizarOrigen.getValue();
		param["paralizar"]=chkParalizarOrigen.getValue();
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
		,{header : '<s:message code="decisionProcedimiento.grid.tipoProcedimiento" text="**tipoProcedimiento"/>', width : 100, dataIndex : 'tipoProcedimiento',renderer:tipoProcedimientoRenderer}
		,{header : '<s:message code="decisionProcedimiento.grid.porcentajeRecuperacion" text="**porcentajeRecuperacion"/>', width : 100, dataIndex : 'porcentajeRecuperacion'}
		,{header : '<s:message code="decisionProcedimiento.grid.plazoRecuperacion" text="**plazoRecuperacion"/>', width : 100, dataIndex : 'plazoRecuperacion'}
		,{header : '<s:message code="decisionProcedimiento.grid.saldoRecuperacion" text="**saldoRecuperacion"/>', width : 100, dataIndex : 'saldoRecuperacion'}
		,{header : '<s:message code="decisionProcedimiento.grid.personas" text="**personas"/>', width : 100, dataIndex : 'personas',renderer:demandadosRenderer}
		
	]);
	

	var procedimientoGrid = new Ext.grid.GridPanel({
		store:procedimientoStore
		,cm:procedimientoCm
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,title:'<s:message code="decisionProcedimiento.grid.titulo" text="**Actuaciones" />'
		,cls:'cursor_pointer'
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,iconCls:'icon_usuario'		
		,style:'padding-right:10px;'
		,width : 780
		,height:100
		,border:true
	});


	procedimientoGrid.on('rowdblclick',function(grid, rowIndex, e){
		var rec=procedimientoStore.getAt(rowIndex);
		var id=rec.get('idProcedimiento');
		var desc=rec.get('descripcion');
		if(id){
			app.abreProcedimiento(id,desc);
			page.fireEvent(app.event.DONE);   
		}
			
	});
	var personas = <json:object name="diccionario">
		<json:array name="diccionario" items="${personas}" var="per">
			<json:object>
				<json:property name="codigo" value="${per.id}"/>
				<json:property name="descripcion" value="${per.apellido1} , ${per.nombre}"/>
			</json:object> 
		</json:array>
	</json:object>
	
	var comboPersonas = app.creaDblSelect(personas, '<s:message code="decisionProcedimiento.demandados" text="**Demandados" />',{labelStyle:labelStyle,allowBlank:false});
			
	var btnAgregarProcedimiento = new Ext.Button({
		text : '<s:message code="app.agregar" text="**Agregar" />'
		,iconCls : 'icon_mas'
		,handler : function(){
			//TODO: agregar validacion
			
			var errores="";
			var tipoActu=tipoActuacion.getValue();
			if(!tipoActuacion.validate())
				errores="<br>Tipo de acción obligatoria.";
			var tipoRec=comboTipoReclamacion.getValue();
			if(!comboTipoReclamacion.validate())
				errores+="<br>Tipo de reclamacion obligatorio.";
			var tipoProc=comboTipoProcedimiento.getValue();
			if(!comboTipoProcedimiento.validate())
				errores+="<br>Tipo de actuación obligatoria.";
			else{
				//Validacion Saldos
				var index = comboTipoProcedimiento.selectedIndex;
				if(index>=0 && saldoARecuperar.validate()){
					var record = optionsTipoProcedimientoStore.getAt( index );
					var saldoMinimo	= record.get('saldoMinimo');
					var saldoMaximo	= record.get('saldoMaximo');
					
					var saldoRec=saldoARecuperar.getValue();
					if(saldoMinimo && saldoRec < saldoMinimo){
						errores+="<br>El saldo a recuperar debe ser mayor o igual que "+saldoMinimo;
					}
					if(saldoMaximo && saldoRec > saldoMaximo){
						errores+="<br>El saldo a recuperar debe ser menor o igual que "+saldoMaximo;
					}
				}
			}
			//var saldoRec=saldoARecuperar.getValue();
			if(!saldoARecuperar.validate())
				errores+="<br>Error en saldo a recuperar";			
			
			var recup=recuperacion.getValue();
			if(!recuperacion.validate())
				errores+="<br>% recuperacion obligatorio";
			var nroMeses=meses.getValue();
			if(!meses.validate())
				errores+="<br>Meses obligatorio";
			var demandados=comboPersonas.getValue();
			if(demandados=='')
				errores+="<br>Seleccione al menos una persona";
			if(errores!=""){
				Ext.Msg.alert("Errores",errores);
				return;
			}
			var arrayDemandados=demandados.split(',');
			for(i=0;i < arrayDemandados.length;i++){
				var rec;
				var demandado=arrayDemandados[i];
				if(i==0){
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
				
			}
		}
	});
	
	
	//Panel Inferior
	
	var chkFinalizarOrigen, chkParalizarOrigen;


	chkFinalizarOrigen=new Ext.form.Checkbox({
		boxLabel :'<b><s:message code="decisionProcedimiento.finalizarorigen" text="**Finalizar origen" /></b>'
		,labelSeparator: ''
		,name:'chkFinalizarOrigen'
		,handler:function(){
			comboCausas.setDisabled(!comboCausas.disabled);
			if(comboCausas.disabled)
				fechaHasta.setDisabled(true);
				
		}
		,readOnly:modoConsulta
		<c:if test="${decisionProcedimiento.finalizada}">
			,checked:true
		</c:if>
		
	});


	chkFinalizarOrigen.on('check', function(checkbox, isCheck){
			chkParalizarOrigen.setValue(false);
			checkbox.setValue(isCheck);

			if (!isCheck && !chkParalizarOrigen.getValue())
			{
				comboCausas.clearValue();
			}
	}); 

	chkParalizarOrigen=new Ext.form.Checkbox({
		boxLabel:'<b><s:message code="decisionProcedimiento.paralizarorigen" text="**Paralizar origen" /></b>'
		,name:'chkParalizarOrigen'
		,labelSeparator: ''
		,handler:function(){
			comboCausas.setDisabled(!comboCausas.disabled);
			if(comboCausas.disabled)
				fechaHasta.setDisabled(true);
		}
		,readOnly:modoConsulta
		<c:if test="${decisionProcedimiento.paralizada}">
			,checked:true
		</c:if>
		
	});

	chkParalizarOrigen.on('check', function(checkbox, isCheck){
			chkFinalizarOrigen.setValue(false);
			checkbox.setValue(isCheck);

			if (isCheck)
				fechaHasta.setDisabled(false);

			if (!isCheck && !chkParalizarOrigen.getValue())
			{
				comboCausas.clearValue();
			}
	}); 



	var dictCausas = <app:dict value="${causaDecision}" />
	
	//store generico de combo diccionario
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
				,fieldLabel : '<s:message code="decisionProcedimiento.causas" text="**Causas" />'
	});
	
	var fechaHasta=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="decisionProcedimiento.fechahasta" text="**Hasta" />'
		,labelStyle:labelStyle
		,disabled: ${decisionProcedimiento.finalizada == null || (decisionProcedimiento.finalizada != null && decisionProcedimiento.finalizada)} 
		,name:'decisionProcedimiento.fechaParalizacion'
		,value:	'<fwk:date value="${decisionProcedimiento.fechaParalizacion}" />'
		
	});
	var comentarios=new Ext.form.TextArea({
		fieldLabel : '<s:message code="decisionProcedimiento.comentarios" text="**Comentarios" />'
		,width:300
		,height:80
		,maxLength:255
		,labelStyle:labelStyle
		,readOnly:modoConsulta
		,name:'decisionProcedimiento.comentarios'
		,value:'<s:message text="${decisionProcedimiento.comentarios}" javaScriptEscape="true" />'
		
	});
	
	var btnAceptarPropuesta = new Ext.Button({
		text : '<s:message code="decisionProcedimiento.aceptarpropuesta" text="**Aceptar Propuesta" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			var params = transform();
			page.submit({
				eventName : 'aceptarPropuesta'
				,formPanel : panelEdicion
				,success : 
	               function(){ 
	        			page.fireEvent(app.event.DONE);          
	               }
				,params:params
			});
		}
	});

	
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
			var params = transform();
			page.submit({
	            eventName : 'update'
	            ,formPanel : panelEdicion
	            ,success : 
	               function(){ 
	        			page.fireEvent(app.event.DONE);          
	               }
	            ,params: params
	         });
	    }
		
	});
	var btnRechazar=new Ext.Button({
		text:'<s:message code="decisionProcedimiento.rechazar" text="**Rechazar" />'
		,iconCls:'icon_rechazar_decision'
		,handler : function(){
			page.submit({
	            eventName : 'rechazar'
	            ,formPanel : panelEdicion
	            ,success: 
	               function(){ 
	        			page.fireEvent(app.event.DONE);          
	               }
	            ,params: {id:decisionId}
	        });
		}
	});

	var panelSuperior={
			title:'<s:message code="decisionProcedimiento.panelprocedimientos" text="**Actuaciones Derivadss" />'			
			,layout:'table'
			//,width:870
			,layoutConfig:{
				columns:3
			}
			,defaults:{xtype:'fieldset',cellCls : 'vtop', autoHeight:true}
			,style:'padding:5px;cellspacing:5px'
			,items:[
				{
					//autoHeight:true
					height:180
					,xtype:'fieldset'
					,style:'padding:10px'
					,title:'<s:message code="procedimientos.edicion.tipoactuacion" text="**Tipo Actuacion" />'
					,width:480
					//,border:false
					,hidden:modoConsulta
					,items:[tipoActuacion,comboTipoProcedimiento,comboTipoReclamacion]
				},{border:false,html:'&nbsp;',width:20},{
					//autoHeight:true
					height:180
					//,colspan:2
					,xtype:'fieldset'
					,style:'padding:10px;cellspacing:5px'
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
					items:btnAgregarProcedimiento
					,width:350
					,autoHeight:true
					,border:false
					,hidden:modoConsulta
				},				
				{
					colspan:3
					,width:800
					,autoHeight:true
					,border:false
					,items:procedimientoGrid
				}

				
			]
	};
	var bbar = []

	if(!modoConsulta)
	{
		if(esSupervisor){
			bbar.push(btnAceptarPropuesta);
			if(!esGestor &&	!${decisionProcedimiento.id==null})
				bbar.push(btnRechazar);
		}
		else {
				bbar.push(btnProponer);
		}
	}
	
	bbar.push(btnCancelar);
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight:true
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,height: 165
				,defaults:{xtype:'fieldset',cellCls : 'vtop',width:840, height:145}
				,items:[{
					title:'<s:message code="decisionProcedimiento.paneldecision" text="**Finalizar/Parar Origen" />'
					,layout:'table'
					,style:'padding:5px'
					,layoutConfig:{
						columns:4
					}
					,defaults:{xtype:'fieldset',border:false,height:140, labelAlign:'top',cellCls:'vtop'}
					,items:[
						{
							items:[
								chkFinalizarOrigen
								,chkParalizarOrigen
							]
							,width:175
						}
						,{
							items:[
								comboCausas,estadoDecision
							]
							,width:200
						}
						,{
							items:[fechaHasta]
							,width:125
						}
						,{
							items:comentarios
							,width:325
						}
					]
				}]
			}
		]
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