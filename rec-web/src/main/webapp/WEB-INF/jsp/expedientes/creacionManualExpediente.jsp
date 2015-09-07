<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var contrato = Ext.data.Record.create([
		{name : 'contrato' }
		,{name : 'tipo' }
		,{name : 'saldo' }
		,{name : 'dias' }
		,{name : 'riesgo' }
		,{name : 'estado' }
		,{name : 'id' }
	]);
	var idExpediente = '${idExpediente}';
	var idExpedienteH = new Ext.form.Hidden({name:'idExpediente', value :'${idExpediente}'}) ;
	
	var idPersona = '${idPersona}';
	var isGestor = '${isGestor}';
	var idArquetipo = '${idArquetipo}';
	//si viene proponer en false, es como si fuera supervisor -> puede activar el expediente directamente sin proponerlo
	var isSupervisor = '${isSupervisor || !proponer }';
	
	var contratosStore = page.getStore({
		flow : 'contratos/listadoContratosData'
		,reader: new Ext.data.JsonReader({
	    	root : 'contratos'
	    	,totalProperty : 'total'
	    }, contrato)
	});
	if (idExpediente == null || idExpediente == ''){
		contratosStore.webflow({idPersona:idPersona});
	}
	var contratosCm = new Ext.grid.ColumnModel([
		    {	header: '<s:message code="listadoContratos.listado.cc" text="**Num. Contrato"/>', width:175, dataIndex: 'contrato'}
		    ,{	header: '<s:message code="listadoContratos.listado.tipo" text="**Tipo"/>', width:125, dataIndex: 'tipo'}
			,{	header: '<s:message code="listadoContratos.listado.saldoVencido" text="**Saldo vencido"/>', width:125, dataIndex: 'saldo', renderer: app.format.moneyRenderer,align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.diasirr" text="**D&iacute;as vencido"/>', width:100, dataIndex: 'dias',align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.riesgo" text="**Riesgos."/>', width:125, dataIndex: 'riesgo', renderer: app.format.moneyRenderer,align:'right'}
     	    ,{	header: '<s:message code="listadoContratos.listado.estado" text="**Estado"/>', width:125, dataIndex: 'estado'}
		    ,{	dataIndex: 'id', fixed: true, hidden:true}
			]
		);


	var cfgContratos = {
			title:'<s:message code="listadoContratos.listado.title" text="**Contratos"/>'
			,store: contratosStore
			,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
			,style:'margin-right:20px;margin-left:10px;margin-top:10px;padding-right:20px;'
			,cm: contratosCm
			,sm: new Ext.grid.RowSelectionModel({
				singleSelect: true
			})
			,autoWidth:true
			,width:830
			,iconCls : 'icon_expedientes'
			,height:150
			,dontResizeHeight:true
			//,viewConfig:{forceFit:true}
			,monitorResize: true
			//,bbar : [  fwk.ux.getPaging(contratosStore)  ]
		}
		var contratosGrid=new Ext.grid.GridPanel(cfgContratos);


	var contratoGeneradorPase;
	contratosGrid.on('rowclick',function(grid, rowIndex, e){
		btnNext.setDisabled(false);
		var rec = grid.getStore().getAt(rowIndex);
		contratoGeneradorPase = rec.get('id');
	});
	contratosGrid.on('rowdblclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		contratoGeneradorPase = rec.get('id');
		step(1);
	});
	

	var labelDescripcion = 
	{ 
		html:'<font color="red"><s:message code="expedientes.creacion.error.sinContrato" text="**La persona no tiene contratos no puede generarse cliente"/></font>'
		,border:false
		,hidden:true
	};

	<c:if test="${nContratos == null || nContratos == 0}">
		labelDescripcion.hidden = false; 
	</c:if>	



	var panel1=new Ext.Panel({
		autoHeight:true
		,border:false
		,items:[labelDescripcion, contratosGrid]
		,id:'panelContratos'
	});



	var panel2=new Ext.Panel({
		border:false
		,id:'panel2'
	});
	var currentPanel=0;
	var step=function(incr){
		currentPanel += incr;
	    if (currentPanel > 1) {
	        currentPanel = 1;
	    }
	    if (currentPanel < 0) {
	        currentPanel = 0;
	    }
		mainPanel.getLayout().setActiveItem(currentPanel);
		if(currentPanel==1){
			panel1.remove();
			panel2.load({
				url:app.resolveFlow('expedientes/creacionManualExpediente_2_GV')
				,scripts:true
				,method:'POST'
				,params:{
					idContrato:contratoGeneradorPase
					,idPersona:idPersona
					,idExpediente:idExpediente
					,isGestor:isGestor
					,isSupervisor:isSupervisor
					,idArquetipo:idArquetipo
				 }
			});
			//panel2.hide();
			mainPanel.getLayout().setActiveItem(currentPanel);
			if (isSupervisor=='true') {
				btnNext.setText('<s:message code="expedientes.creacion.activar" text="**Activar"/>');
				btnNext.enable();
			} else if('${propuesta.id}'!='') {
				btnNext.setText('Proponer');
				btnNext.disable();
			} else if (isGestor=='true' || (isGestor=='false' && isSupervisor=='false') ) {
				btnNext.setText('<s:message code="expedientes.creacion.proponer" text="**Proponer"/>');
				btnNext.enable();
			}
		}else{
			btnNext.setHandler(function(){
				step(1)
			})
		}
		
	};
	
	var btnNext=new Ext.Button({
		text:'<s:message code="app.botones.siguiente" text="**Siguiente"/>'
		,disabled:true
		,iconCls:'icon_siguiente'
		,handler:function(){
			if (currentPanel == 1){
				page.fireEvent('update');		
			}else{
				step(1);
			}
			
		}
		
	});
	var btnPrev=new Ext.Button({
		text:'<s:message code="app.botones.atras" text="**Atras"/>'
		,iconCls:'icon_atras'
		,disabled:true
		,handler:function(){
			step(-1)
		}
	});
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			if (currentPanel == 1){
				page.fireEvent('cancelar');		
			}else{
				page.fireEvent(app.event.CANCEL);
			}
		}
	});
	var mainPanel=new Ext.Panel({
		layout:'card'
		,id:'mainPanel'
		,bodyStyle:'padding:10px'
		,layoutConfig:{
			deferredRender : true
		}
		,border : false
		,activeItem:0
		,autoHeight:true
		,tbar:[btnCancelar,'->',btnNext]
		,items:[panel1,panel2]
	});

	page.add(mainPanel);
	if (idExpediente != null && idExpediente != ''){
		step(1);
	}
</fwk:page>