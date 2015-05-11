<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){

		var panel=new Ext.Panel({
			title:'<s:message code="menu.clientes.consultacliente.antecedentesTab.title" text="**Antecedentes"/>'
			,height: 445
			,autoWidth:true
			,bodyStyle : 'padding:10px'
			,nombreTab : 'antecedentesPanel'
		});


		panel.on('render', function() {
	
			var show=false;
			var labelStyle='font-weight:bold;width:150px'
	
			var fechaVerificacion = new Ext.ux.form.StaticTextField({
				fieldLabel:'<s:message code="menu.clientes.consultacliente.antecedentestab.fechaverif" text="**Fecha Verificación"/>'
				<app:test id="fechaVerificacion" addComa="true" />
				,labelStyle:labelStyle
				,name:'fechaVerificacion'
				,value:'<fwk:date value="${antecedente.fechaVerificacion}" />'
			});
			var tituloobservaciones = new Ext.form.Label({
			   	text:'<s:message code="menu.clientes.consultacliente.antecedentestab.observaciones" text="**Observaciones" />'
				,style:'font-weight:bolder; font-size:11'
				}); 
			var observaciones=new Ext.form.TextArea({
				fieldLabel:'<s:message code="menu.clientes.consultacliente.antecedentestab.observaciones" text="**Observaciones" />'
				<app:test id="observacionesAntecedente" addComa="true" />
				,readOnly:true
				,hideLabel: true
				,labelStyle:labelStyle
				,style:'margin-left:5px; width:auto'
				,width:'90%'
				,maxLength:250
				,name:'observaciones'
				,value:'<s:message text="${antecedente.observaciones}" javaScriptEscape="true" />'
			});
	
	
			var refrescarObservaciones = function(){
				panelObservaciones.load({
					url : app.resolveFlow('clientes/antecedenteObservacionData')
					,params : {id : '${persona.id}'}
				});
			};
	
			var riesgos = {"riesgos":[{cc:'1234',tipo:'Hipoteca',posicionirregular:'4',maxdias:'5',cantirregular:'6',fecharegulariz:'01/09/2008'}]};
	
	
			var interno = Ext.data.Record.create([
					{name:'descripcion'}
					,{name:'posMax'}
					,{name:'diasMax'}
					,{name:'fechaRegularizacion'}	
			]);
	
			var antIntSt = page.getStore({
				flow : 'clientes/antecedentesInternos'
				,pageSize : 20
				,reader : new Ext.data.JsonReader({root : 'antecedentes'}, interno)
				,remoteSort : false
			});
			
			antIntSt.on('load', setTituloTabla);


			var externo = Ext.data.Record.create([
					{name:'idAntExt'}
					,{name:'descripcion'}
					,{name:'numIncidenciasJudiciales'}
					,{name:'fechaIncidenciaJudicial'}	
			]);

			var antExtSt = page.getStore({
				flow : 'clientes/antecedenteExternoData'
				,pageSize : 20
				,reader : new Ext.data.JsonReader({root : 'antExt'}, externo)
				,remoteSort : false
			});
			
			var antInternosCm = new Ext.grid.ColumnModel([
				{	header: '<s:message code="menu.clientes.consultacliente.antecedentestab.descripcion" text="**Descripcion"/>', 
			    	width: 240, sortable: true, dataIndex: 'descripcion'},
			    	
			    {	header: '<s:message code="menu.clientes.consultacliente.antecedentestab.posicionirregularMax" text="**Pos. Irregular Maxima"/>', 
			    	width: 100, sortable: true, dataIndex: 'posMax',renderer: app.format.moneyRenderer, align:'right'},	
			    
		    	{	header: '<s:message code="menu.clientes.consultacliente.antecedentestab.maxdias" text="**Dias Maximo en Irregular"/>', 
			    	width: 100, sortable: true, dataIndex: 'diasMax', align:'right'},
			    	
		    	{	header: '<s:message code="menu.clientes.consultacliente.antecedentestab.fecharegulariz" text="**Fecha de Regularizacion"/>', 
		    		width: 100, <%--renderer:Ext.util.Format.dateRenderer('m/d/Y'),--%> sortable: true,
		    		dataIndex: 'fechaRegularizacion'}
			]);
	
			var antExternosCm = new Ext.grid.ColumnModel([
				{	header: '<s:message code="menu.clientes.consultacliente.antecedentestab.descripcion" text="**Descripcion"/>', 
			    	width: 150, sortable: true, dataIndex: 'descripcion'},
			    	
			    {	header: '<s:message code="menu.clientes.consultacliente.antecedentestab.numero" text="**Numero"/>', 
			    	width: 50, sortable: true, dataIndex: 'numIncidenciasJudiciales',align:'right'},	
			    
		    	{	header: '<s:message code="menu.clientes.consultacliente.antecedentestab.fechaUlt" text="**Fecha Ultima"/>', 
		    		width: 100, <%--renderer:Ext.util.Format.dateRenderer('m/d/Y'),--%> sortable: true,
		    		dataIndex: 'fechaIncidenciaJudicial',align:'right'}
			]);


			function getTituloTabla()
			{
				var titulo 	= '<s:message code="menu.clientes.consultacliente.antecedentesTab.antInt" text="**Antecedentes Internos"/>';
				titulo += ' ('; 
				titulo +=antIntSt.getCount();
				titulo += ')';
	
				return titulo;			
			}			
			
			function setTituloTabla()
			{
				
				antInternosGrid.setTitle(getTituloTabla());								
			}				
				
				
			var antInternosGrid =app.crearGrid(antIntSt,antInternosCm,{
				title:getTituloTabla()
				,style : 'margin-bottom:10px;padding-right:10px'
				,iconCls : 'icon_antecedentes'
				,height : 208
				,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
				<app:test id="antInternosGrid" addComa="true" />
			});
				
	
			<sec:authorize ifAllGranted="EDITAR_ANTECEDENTES">
			var btnGuardar=new Ext.Button({
				text:'<s:message code="app.guardar" text="**Guardar" />'
				,iconCls : 'icon_ok'
				,disabled:true
				,handler:function(){
					
				}
			});
			
			var btnEditarAntecedenteExterno = new Ext.Button({
		           	text: '<s:message code="app.editar" text="**Editar" />'
					<app:test id="btnEditarAntecedenteExterno" addComa="true" />
		           	,iconCls : 'icon_edit'
					,cls: 'x-btn-text-icon'
		           	,handler:function(){
		           	   	var w = app.openWindow({
							flow : 'clientes/antecedentesExternos'
							,width:400
							,title : '<s:message code="menu.clientes.consultacliente.antecedentesTab.editarAntecedente" text="**Editar" />' 
							,params : {idPersona:"${persona.id}"}
						});
						w.on(app.event.DONE, function(){
							w.close();
							antExtSt.webflow({id:"${persona.id}"});
							//refrescarObservaciones();
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
		         }
			});
	
	
	
			var btnEditar = new Ext.Button({
				text: '<s:message code="app.editar" text="**Editar" />'
				<app:test id="btnEditarAntecedente" addComa="true" />
		           	,iconCls : 'icon_edit'
					,cls: 'x-btn-text-icon'
		           	,handler:function(){
		           	   	var w = app.openWindow({
							flow : 'clientes/antecedentes'
							,width:650
							,title : '<s:message code="menu.clientes.consultacliente.antecedentesTab.editarAntecedente" text="**Editar" />' 
							,params : {idPersona:"${persona.id}"}
						});
						w.on(app.event.DONE, function(){
							w.close();
							refrescarObservaciones();
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
		         }
			});
			</sec:authorize>
			
			var cfgExternos={
				title:'<s:message code="antecedentes.edicion.titulo" text="**Antecedentes Externos"/>'
				<app:test id="antExternosGrid" addComa="true" />
				,store: antExtSt
				,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
				,cm: antExternosCm
				,height:164
				,width:370
				,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
				,iconCls : 'icon_antecedentes_ext'
				,viewConfig:{forceFit:true}
				,monitorResize:true
				<sec:authorize ifAllGranted="EDITAR_ANTECEDENTES">,bbar:[btnEditarAntecedenteExterno]</sec:authorize>
			};
			var antExternosGrid = new Ext.grid.GridPanel(cfgExternos);
	
			// El componente Ext.form.FieldSet aparentemente no refrezca bien flows
			var panelObservaciones = new Ext.form.FormPanel({
				bodyStyle:'padding:5px'
				,border:false
				,autoWidth:true			
				,items:[fechaVerificacion,tituloobservaciones,observaciones]
			});
			var fieldSetObservaciones = new Ext.form.FieldSet({
				title:'<s:message code="menu.clientes.consultacliente.antecedentesTab.panelvigencia" text="**Control Vigencia Datos"/>'
				,bodyStyle:'padding-left:5px;padding-top:5px'
				,autoWidth:true
				,autoHeight:true
				,items:[
					panelObservaciones
					<sec:authorize ifAllGranted="EDITAR_ANTECEDENTES">,{items:btnEditar,border:false,style:'text-align:left'}</sec:authorize>
				]
			
			});
			
			var panelInferior=new Ext.Panel({
				layout:'column'
				,layoutConfig:{
					columns:2
				}
				,autoHeight:true
				,border:false
				,bodyStyle:'padding-top:10px'
				,autoWidth:true
				,defaults:{columnWidth:.5}
				,items:[{
						items:antExternosGrid
						,layout:'fit'
						,border:false
						,style:'padding-right:10px'
					},{
						items:[fieldSetObservaciones]
						,border:false
					}
				]
			});
			panel.add(antInternosGrid);
			panel.add(panelInferior);


			panelInferior.on('render', function(){
				antExtSt.load({params:{id:"${persona.id}"}});
				antIntSt.load({params:{id:"${persona.id}"}});
				//antIntSt.webflow({id:"${persona.id}"});
			});
								
		});
		
		
		return panel;
})()
