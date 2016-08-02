<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>
	var enConformacion = true;
	var prcPCO = '<fwk:const value="es.capgemini.pfs.asunto.model.DDTipoActuacion.TIPO_ACTUACION_PRECONTENCIOSO" />';
	var cntBloq = '<fwk:const value="es.capgemini.pfs.asunto.model.DDTipoActuacion.TIPO_ACTUACION_CNT_BLOQUEADOS" />';
	var ejeCamb = '<fwk:const value="es.capgemini.pfs.asunto.model.DDTipoActuacion.TIPO_ACTUACION_EJECUTIVO_CAMBIARIO" />';
	
	var tpoPCO = '<fwk:const value="es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento.TIPO_PRECONTENCIOSO" />';
	var tpoNoLitg = '<fwk:const value="es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento.TIPO_NO_LITIGAR" />';
	
	var recTotal = '<fwk:const value="es.capgemini.pfs.asunto.model.DDTipoReclamacion.TIPO_RECLAMACION_TOTAL_DEUDA" />';

	var enConformacionHidden = new Ext.form.Hidden({
		name:'enConformacion'
		,value: enConformacion
	});

	/*
	Funciones auxiliares para hacer submit de los combos.
	*/
	
	var rearmarArray = function(elArray, valor){
		var esta = false;
		var nuevoArray = new Array();
		var j = 0;
		for (var i=0; i < elArray.length; i++){
			if(valor!=elArray[i]){
				//Si es distinto quiere decir que no esta deseleccionando un elemento,
				//por lo tanto lo tengo que pasar al nuevo array. 
				nuevoArray[j++]=elArray[i];
			}else{
				//Si es igual (lo esta deseleccionando), 
				//hay que sacarlo del listado de seleccionados.
				esta = true;
			}
		}
		if (!esta){
			//Si copio todo el array y no estaba lo agrego porque es nuevo.
			nuevoArray[nuevoArray.length] = valor;
		}
		return nuevoArray;
	}
	
	var armarString = function(elArray){
		var s = "";
		for (var i=0; i < elArray.length; i++){
			if (s!=""){
				s+="-";
			}
			s+=elArray[i];
		}
		return s;
	}
	
	/**/	
	


	var style='margin-bottom:1px;margin-top:1px';
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:150px'	
	var labelStyle='font-weight:bolder;width:150';
	var saldoOriginalVencido = app.creaLabel('<s:message code="procedimientos.edicion.saldovencido" text="**Saldo vencido" />',app.format.moneyRenderer(${procedimiento.saldoOriginalVencido}),{labelStyle:labelStyle});
	var saldoOriginalNoVencido = app.creaLabel('<s:message code="procedimientos.edicion.saldonovencido" text="**Saldo no vencido" />',app.format.moneyRenderer(${procedimiento.saldoOriginalNoVencido}),{labelStyle:labelStyle});
	var idProcedimiento = new Ext.form.Hidden({
		name:'idProcedimiento'
	});
	
	var seleccionPersonas = new Ext.form.Hidden({
		name:'seleccionPersonas'
	});
		
	var seleccionContratos = new Ext.form.Hidden({
		name:'seleccionContratos'
	});
	
	var sOrigVenc = new Ext.form.Hidden({
		name:'saldoOriginalVencido'
	});
	
	var sOrigNoVenc = new Ext.form.Hidden({
		name:'saldoOriginalNoVencido'
	});
	
	var litigarHidden = new Ext.form.Hidden({
		name: 'litigar'
		,value:'${litigar}'
	});
	
	var personasSeleccionadasString = "";
	
	var personasSeleccionadas = new Array();
	
	var contratosSeleccionadosString = "";

	
	var contratosSeleccionados = new Array();

	var cexSeleccionados = new Array();

	var asuntoLabel = app.creaLabel('<s:message code="asuntos.listado.asunto" text="**Asunto"/>'
		<c:if test="${idAsunto!=null}">
        	,'<s:message text="${asunto.nombre}" javaScriptEscape="true" />'
		</c:if>
        ,{labelStyle:labelStyle});

	var idAsuntoH = new Ext.form.Hidden({
		name:'asunto'
		<c:if test="${idAsunto!=null}">
        	,value:'${asunto.id}'
		</c:if>
	});
	

	var codTipoAsu = new Ext.form.Hidden({
		name:'codigoTipoAsunto'
		<c:if test="${asunto != null && asunto.tipoAsunto != null}">
        	,value:'${asunto.tipoAsunto.codigo}'
		</c:if>
	});
	

	var saldoARecuperar = 
		app.creaNumber('saldorecuperar',
			'<s:message code="procedimientos.edicion.saldorecuperacion" text="**Principal " />',
			'0',
			{labelStyle:labelStyleTextField
			<app:test id="saldoARecuperarField" addComa="true" />
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:14
			,readOnly: !enConformacion
			,disabled: !enConformacion
			,autoCreate : {tag: "input", type: "text",maxLength:"14", autocomplete: "off"}}
	);
	
	var recuperacion  = app.creaNumber('recuperacion',
		'<s:message code="procedimientos.edicion.recuperacion" text="**% Recuperacion " />',
			'0',
		{labelStyle:labelStyleTextField
		,style:style
		,allowDecimals: false
		,allowNegative: false
		,maxLength:3
		,readOnly: !enConformacion
		,disabled: !enConformacion
		,autoCreate : {tag: "input", type: "text",maxLength:"3", autocomplete: "off"}}
	);
	
	var meses = new Ext.form.NumberField({
		name : 'plazo'
		,allowDecimals: false
		,allowNegative: false
		,fieldLabel : '<s:message code="procedimientos.edicion.mesesrecuperacion" text="**Plazo (meses)" />'
		,labelStyle:labelStyleTextField
		,maxLength:2
		,style:style
		,readOnly: !enConformacion
		,disabled: !enConformacion
		,autoCreate : {tag: "input", type: "text",maxLength:"2", autocomplete: "off"}
		,value: 0
	});
	

	<c:if test="${asuntos!=null}">
	var dicAsuntos =
		<json:object name="dicAsuntos">
			<json:array name="asuntos" items="${asuntos}" var="a">
					<json:object>
						<json:property name="codigo" value="${a.id}" />
						<json:property name="descripcion" value="${a.nombre}" />
					</json:object>
			</json:array>
		</json:object>;
	</c:if>

	<c:if test="${asuntos==null}">
		var idAsunto; 
		var nombreAsunto;

		<c:if test="${idAsunto!=null}">
			idAsunto = '${asunto.id}';
        	nombreAsunto = '<s:message text="${asunto.nombre}" javaScriptEscape="true" />';
		</c:if>
		<c:if test="${idAsunto==null}">
			idAsunto = '${procedimiento.asunto.id}';
        	nombreAsunto = '${procedimiento.asunto.nombre}';
		</c:if>

		var dicAsuntos = {"asuntos":[{"codigo":idAsunto,"descripcion":nombreAsunto}]};
	</c:if>

	var optionsAsuntosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : dicAsuntos
	       ,root: 'asuntos'
	});


	var comboAsuntos = new Ext.form.ComboBox({
	    name:'asunto'
	    <app:test id="asuntosCombo" addComa="true" />
	    ,hiddenName:'asunto'
	    ,store: optionsAsuntosStore
	    ,displayField:'descripcion'
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,emptyText:'----'
	    ,valueField: 'codigo'
		,width:250
		,labelStyle:labelStyle
	    ,editable : false
		,fieldLabel : '<s:message code="procedimientos.edicion.asunto" text="**Asunto" />'
		<c:if test="${idAsunto!=null}">
				,value:'${idAsunto}'
		</c:if>
		,readOnly: true
	});


	<%-- Comobo para seleccionar propuestas, solo estara visible si el tipo de asunto es ACUERDO --%>
	
	var propuestaRecord = Ext.data.Record.create([
		 {name:'fechaPropuesta'}
		,{name:'solicitante'}
		,{name:'idAcuerdo'}
	]);
	
	var optionsPropuestasStore = page.getStore({
	       flow: 'propuestas/getPropuestasElevadasDelExpediente'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'acuerdos'
	    }, propuestaRecord)    
	});
	
	var  TIPO_ASUNTO_ACUERDO = "<fwk:const value="es.capgemini.pfs.asunto.model.DDTiposAsunto.ACUERDO" />";
	
	var propuestaTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{fechaPropuesta}&nbsp;&nbsp;---&nbsp;&nbsp;{solicitante}</p>',
        '</div></tpl>'
    );


	var comboPropuestas = new Ext.form.ComboBox({
	    hiddenName:'propuesta'
	    ,hiddenValue: 'null'
	    <app:test id="propuestasCombo" addComa="true" />
	    ,store: optionsPropuestasStore
	    ,displayField:'fechaPropuesta'
	    ,tpl:propuestaTemplate
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,hidden:true
	    ,emptyText:'----'
	    ,valueField: 'idAcuerdo'
		,width:250
		,labelStyle:labelStyle
	    ,editable : false
	    ,itemSelector: 'div.search-item'
		,fieldLabel : '<s:message code="procedimientos.edicion.propuestas" text="**Propuestas" />'
		,onSelect: function(record) {
			<%--
			if(record.data.idAcuerdo != null){
				comboPropuestas.setValue(record.data.idAcuerdo);
				comboPropuestas.collapse();
				comboPropuestas.focus();
				Ext.Ajax.request({
					url : page.resolveUrl('propuestas/contratosIncluidosEnLosTerminosDeLaPropuesta'), 
					params : {
								idPropuesta:record.data.idAcuerdo
							},
					method: 'POST',
					success: function ( result, request ) {
							var resultado = Ext.decode(result.responseText);
							var contratos = new Array();
							for(i=0;i < resultado.contratos.length; i++){
								contratos.push(resultado.contratos[i].id);
							}
							var position = 0;
							
							contratosStore.each( function(record){
								if(contratos.indexOf(record.data.id) != -1){
									myCboxSelModelContratos.selectRow(position,true);
								}else if(myCboxSelModelContratos.isSelected( position )){
									myCboxSelModelContratos.deselectRow(position,true);
								}
								position++;
	    					});
					}
				});
			}else{
				comboPropuestas.collapse();
				comboPropuestas.focus();			
			}
			 --%>
		}
	});
	
	optionsPropuestasStore.on('load', function(){
	  optionsPropuestasStore.add(new optionsPropuestasStore.recordType({
	    fechaPropuesta: '',
	    solicitante: '',
	    idAcuerdo: null
	  }, 0));
	});
	
	if(${asunto != null && asunto.tipoAsunto != null}){
		codAsu = "${asunto.tipoAsunto.codigo}";
		if(codAsu == TIPO_ASUNTO_ACUERDO){
			optionsPropuestasStore.webflow({idExpediente:${idExpediente}});
			comboPropuestas.setVisible(true);
			saldoARecuperar.setVisible(false);
			recuperacion.setVisible(false);
			meses.setVisible(false);
		}
	}

	var dictTipoActuacion = <app:dict value="${tiposActuacion}" />;

	
	var optionsTipoActuacionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : dictTipoActuacion
	       ,root: 'diccionario'
	});
	
	var tipoActuacion = new Ext.form.ComboBox({
	    name:'actuacion'
	    <app:test id="tipoActuacionCombo" addComa="true" />
	    ,hiddenName:'actuacion'
	    ,store: optionsTipoActuacionStore
	    ,displayField:'descripcion'
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,emptyText:'----'
		,width:250
	    ,valueField: 'codigo'
		,labelStyle:labelStyle
	    ,editable : false
		,disabled: !enConformacion
		,fieldLabel : '<s:message code="procedimientos.edicion.tipoactuacion" text="**Tipo Acci�n" />'
		,readOnly: true	
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
	
	optionsTipoProcedimientoStore.on('load',function() {
		<c:if test="${litigar==true}" >
			comboTipoProcedimiento.setValue(tpoPCO);
			//comboTipoProcedimiento.fireEvent('select');
		</c:if>
		<c:if test="${litigar==false}" >
			comboTipoProcedimiento.setValue(tpoNoLitg);
		</c:if>
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
				,labelStyle:labelStyle
				,editable: false
				,disabled: !enConformacion
				,fieldLabel : '<s:message code="procedimientos.edicion.tipoprocedimiento" text="**Tipo Procedimiento" />'
				,readOnly: true
	});
	
<%--
	if ('${procedimiento.tipoActuacion.codigo}' != '')
	{
		optionsTipoProcedimientoStore.load({
			params:{codigo:'${procedimiento.tipoActuacion.codigo}'}
			,callback: function()
			{
				if ('${procedimiento.tipoProcedimiento.codigo}' != '')
				{
					comboTipoProcedimiento.setValue('${procedimiento.tipoProcedimiento.codigo}');
					if('${procedimiento.tipoProcedimiento.codigo}' == "NOLIT"){
						var el = Ext.getCmp("tmp");
						el.setVisible(true);
						fieldSetLitigar.show();
					}
				}
				if('${procedimiento.tipoActuacion.codigo}' == "PCO"){
					var el = Ext.getCmp("tmp");
					el.setVisible(true);
					fieldSetPco.show();
					if('${procedimientoPco}' != null){
						comboTipoAccionPropuestaAIniciar.fireEvent('select', comboTipoAccionPropuestaAIniciar);
					}
				}
			}
		});
	}
--%>
	
	var dictTipoReclamacion = <app:dict value="${tiposReclamacion}" />;
	
	//store generico de combo diccionario
	var optionsTipoReclamacionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoReclamacion
	});
	
	
	
	var comboTipoReclamacion = new Ext.form.ComboBox({
				name:'tipoReclamacion'
				<app:test id="tipoReclamacionCombo" addComa="true" />
				,hiddenName:'tipoReclamacion'
				,store:optionsTipoReclamacionStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,width:250
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,disabled: !enConformacion
				,fieldLabel : '<s:message code="procedimientos.edicion.tiporeclamacion" text="**Tipo Reclamacion" />'
				,readOnly: true
				,value: recTotal
	});
	
	var Cliente = Ext.data.Record.create([
		{name:'id'}
		,{name:'nombre'}
		,{name:'apellido1'}
		,{name:'apellido2'}
		//,{name:'tipoIntervencion'}
		,{name:'deudaIrregular'}
		,{name:'totalSaldo'}
		,{name:'asiste'}
		,{name:'cntId'}
	]);

	var clientesIncluirStore = page.getStore({
		eventName : 'listado'
		,flow:'expedientes/personasParaProcedimiento'
		,reader: new Ext.data.JsonReader({
			root: 'clientes'
		}, Cliente)
	});



/** DEFINICION DEL CHECK COLUM PARA LA LISTA DE CONTRATOS**/	
	
 
	var myCboxSelModelContratos = new Ext.grid.CheckboxSelectionModel({
  		singleSelect: false,
  		header:''
	});
	
    var actualizaDatosContratosMarcados = function(checked, record){
    
    	if (!enConformacion) return;
     	
     	record.data['seleccionado'] = checked;
     	
        contratosSeleccionados = rearmarArray(contratosSeleccionados,record.data['id']);
		cexSeleccionados = rearmarArray(cexSeleccionados,record.data['idCex']);
        contratosSeleccionadosString = armarString(contratosSeleccionados);
        
        //Falta el campo hidden para agregar al fieldSetActuacion
        seleccionContratos.setValue(cexSeleccionados);
        record.set(this.dataIndex, !eval(record.data[this.dataIndex]));
        clientesIncluirStore.webflow({
			contratos:contratosSeleccionadosString,
			idProcedimiento:'0'
		});
		clientesIncluirGrid.getView().refresh();
		
		// Recalculamos los saldos recuperados para el procedimiento
		var totalSaldoOriginalVencido = new Number(sOrigVenc.getValue());
		var totalSaldoOriginalNoVencido = new Number(sOrigNoVenc.getValue());
		
		if(checked) {
			totalSaldoOriginalVencido += record.data['saldoIrregular'];
			totalSaldoOriginalNoVencido += record.data['saldoNoVencido'];
		} else {
			totalSaldoOriginalVencido -= record.data['saldoIrregular'];
			totalSaldoOriginalNoVencido -= record.data['saldoNoVencido'];
		}
		
		sOrigVenc.setValue(totalSaldoOriginalVencido);
		sOrigNoVenc.setValue(totalSaldoOriginalNoVencido);
		saldoOriginalVencido.setValue(app.format.moneyRenderer(totalSaldoOriginalVencido));
		saldoOriginalNoVencido.setValue(app.format.moneyRenderer(totalSaldoOriginalNoVencido));
    
    };
    
    var contratosRowselectListener = function (el, rowIndex, r){
		actualizaDatosContratosMarcados(true, r);
		Ext.fly(this).addClass('x-grid3-row-checker-on');
    };
    
    var contratosRowDeselectListener = function (el, rowIndex, r){
		actualizaDatosContratosMarcados(false, r);
		Ext.fly(this).removeClass('x-grid3-row-checker-on');
    };
	
	myCboxSelModelContratos.addListener('rowselect', contratosRowselectListener);
	myCboxSelModelContratos.addListener('rowdeselect', contratosRowDeselectListener);


/******/
	//DEFINICION DEL CHECKCOLUM para personas
	Ext.grid.CheckColumn = function(config){
    	Ext.apply(this, config);
	    if(!this.id){
	        this.id = Ext.id();
		}
	    this.renderer = this.renderer.createDelegate(this);
	};	

	Ext.grid.CheckColumn.prototype ={
    	init : function(grid){
        	this.grid = grid;
        	this.grid.on('render', function(){
        	    var view = this.grid.getView();
    	        view.mainBody.on('mousedown', this.onMouseDown, this);
        	}, this);
    	},

    	onMouseDown : function(e, t){
			if (!enConformacion) return;
			//El if es para que el evento solo se dispare si el click es sobre el checkbox.
			//Si se saca se activa al hacer click en cualquier lugar de la fila    	
    	    if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
	            e.stopEvent();
            	//Saca el indice de la fila en la que se hizo click
            	var index = this.grid.getView().findRowIndex(t);
            	//trae el registro del store de la tabla correpsondiente a la fila clickeada
            	var record = this.grid.store.getAt(index);
            	personasSeleccionadas = rearmarArray(personasSeleccionadas,record.data['id']);
            	personasSeleccionadasString = armarString(personasSeleccionadas);  
            	seleccionPersonas.setValue(personasSeleccionadasString);
            	//alert(this.dataIndex+" "+record.data['id'])
            	//Cambia el valor del check
            	record.set(this.dataIndex, !record.data[this.dataIndex]);
        	}
    	},

	    renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'"> </div>';
    	}
	}; 


		
/******/	
	

	var Contrato = Ext.data.Record.create([
		{name:'idCex'}
		,{name:'id'}
		,{name:'cc'}
		,{name:'tipo'}
		,{name:'saldoNoVencido'}
		,{name:'saldoIrregular'}
		,{name:'saldoTotal'}
		,{name:'idPersona'}
		,{name:'otrosint'}
		,{name:'tipointerv'}
		,{name:'seleccionado'}
	]);

 	var contratosStore = page.getStore({
		eventName : 'listado'
		,flow:'expedientes/contratosDeUnExpedienteSinPaginar'
		,reader: new Ext.data.JsonReader({
			root: 'contratos'
		}, Contrato)
	});
	
	//contratosStore.webflow({idExpediente:${idExpediente}, idProcedimiento:'${procedimiento.id}'});

<%--
	var checkColumnContratos = new Ext.grid.CheckColumn2({
		header : '<s:message code="procedimientos.edicion.grid.incluido" text="**Incluir" />'
		,width: 100,dataIndex : 'seleccionado'
	});

	var contratosCm = new Ext.grid.ColumnModel([
		{dataIndex : 'idCex', hidden:true, fixed:true}
		,{dataIndex : 'id', hidden:true, fixed:true}
		,{header : '<s:message code="procedimientos.edicion.gridContratos.codigo" text="**Contrato"/>',width: 200, dataIndex : 'cc' }
		,{header : '<s:message code="procedimientos.edicion.gridContratos.tipo" text="**Tipo"/>',width: 200, dataIndex : 'tipo' }
		,{header : '<s:message code="procedimientos.edicion.gridContratos.saldoVencido" text="**Saldo Vencido"/>',width: 125, dataIndex : 'saldoIrregular', renderer: app.format.moneyRenderer, align:'right' }
		,{header : '<s:message code="procedimientos.edicion.gridContratos.saldoTotal" text="**Saldo Total"/>',width: 125, dataIndex : 'saldoTotal' , renderer: app.format.moneyRenderer, align:'right' }
		,checkColumnContratos
	]);
	
	var contratosGrid = new Ext.grid.GridPanel({
		store : contratosStore
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,title:'<s:message code="procedimientos.edicion.grid.contratos.titulo" text="**Contratos a incluir" />'
		,cm : contratosCm
		,style:'padding-right:10px'
		,plugins: checkColumnContratos
		,clicksToEdit:1
		,width: 650
		,height : 130
		,doLayout: function() {
			  var parentSize = panelEdicion.getSize(true); 
			  this.setWidth(parentSize.width-10);//el  -10 es un margen
			  Ext.grid.GridPanel.prototype.doLayout.call(this);
		}
	});
 --%>	
 
 	var contratosCm = new Ext.grid.ColumnModel([
		{dataIndex : 'idCex', hidden:true, fixed:true}
		,{dataIndex : 'id', hidden:true, fixed:true}
		,{header : '<s:message code="procedimientos.edicion.gridContratos.codigo" text="**Contrato"/>',width: 200, dataIndex : 'cc' }
		,{header : '<s:message code="procedimientos.edicion.gridContratos.tipo" text="**Tipo"/>',width: 200, dataIndex : 'tipo' }
		,{header : '<s:message code="procedimientos.edicion.gridContratos.saldoVencido" text="**Saldo Vencido"/>',width: 125, dataIndex : 'saldoIrregular', renderer: app.format.moneyRenderer, align:'right' }
		,{header : '<s:message code="procedimientos.edicion.gridContratos.saldoTotal" text="**Saldo Total"/>',width: 125, dataIndex : 'saldoTotal' , renderer: app.format.moneyRenderer, align:'right' }
		,myCboxSelModelContratos
	]);
	
	var contratosGrid = app.crearEditorGrid(contratosStore,contratosCm,{
        title:'<s:message code="procedimientos.edicion.grid.contratos.titulo" text="**Contratos a incluir" />'
		,sm: myCboxSelModelContratos
        ,cls:'cursor_pointer'
		,style:'padding-right:10px'
        ,height:130
        ,width: 650
        ,parentWidth:885
		,loadMask: true
        ,viewConfig: {forceFit: true}
        ,autoExpand:true
        ,clicksToEdit: 1
       	,style:'padding-top:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_contratos'
		,autoWidth: true
    });
    
    contratosGrid.on('render', function() {
    	contratosStore.webflow({idExpediente:${idExpediente}, idProcedimiento:'${procedimiento.id}'});
    });
    
	var inicializarContratosPersonas = function() {
		for (var i=0; i < contratosStore.getTotalCount(); i++){
			if(contratosStore.getAt(i).data.seleccionado==true){
				contratosSeleccionados[contratosSeleccionados.length] = contratosStore.getAt(i).data.id;
				cexSeleccionados[cexSeleccionados.length] = contratosStore.getAt(i).data.idCex;
				if (contratosSeleccionadosString != ""){
					contratosSeleccionadosString += "-";
				}
				contratosSeleccionadosString += contratosStore.getAt(i).data.id;
			}
		}
		seleccionContratos.setValue(cexSeleccionados);
		clientesIncluirGrid.getView().refresh();
        clientesIncluirStore.webflow({
			contratos:contratosSeleccionadosString,
			idProcedimiento:'0'
		});
	};

	contratosStore.on('load', function() {
		var contratosASeleccionarString = '${idContratos}';
		var contratosSelArray = contratosASeleccionarString.split("-");

		contratosGrid.getSelectionModel().selections.clear();
		for (var i=0;i< contratosSelArray.length ;i++) {
			var position = this.findExact('id', parseInt(contratosSelArray[i]));
			if (position > -1) {
				this.getAt(position).data.seleccionado = true;
				contratosGrid.getSelectionModel().selectRow(position,true);

				//Ext.fly(contratosGrid.getSelectionModel().selections.get(position)).addClass('x-grid3-row-checker-on');
				//contratosGrid.getView().refresh();
			}
		}
		contratosStore.commitChanges();
		
		inicializarContratosPersonas();
	});
	
	
	

	clientesIncluirStore.on('load', function() {
		personasSeleccionadas = new Array();
		personasSeleccionadasString = '';
		clientesIncluirGrid.getSelectionModel().selections.clear();
		for (var i=0; i < clientesIncluirStore.getTotalCount(); i++){
			//if(clientesIncluirStore.getAt(i).data.asiste==true){
				personasSeleccionadas[personasSeleccionadas.length] = clientesIncluirStore.getAt(i).data.id;
				if (personasSeleccionadasString != ""){
					personasSeleccionadasString += "-";
				}
				personasSeleccionadasString += clientesIncluirStore.getAt(i).data.id;
				
				
				
				clientesIncluirStore.getAt(i).data.asiste=true;
				clientesIncluirGrid.getSelectionModel().selectRow(i,true);
				
				
				
				if (clientesIncluirGrid.getSelectionModel().isLocked()) {
					clientesIncluirGrid.getSelectionModel().unlock();
				}				
				clientesIncluirGrid.getSelectionModel().selectRow(i, true);
			//}
		}
       	seleccionPersonas.setValue(personasSeleccionadasString);
       	clientesIncluirStore.commitChanges();
	});

	var fieldSetEstimacion = new Ext.form.FieldSet({
		title:'<s:message code="procedimientos.edicion.estimacion" text="**Estimacion" />'
		//,autoHeight:true
		,height:180
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:20px'
				,autoHeight:true
				,items:[
					saldoOriginalVencido
					,saldoOriginalNoVencido
					,saldoARecuperar
					,recuperacion
					,meses
				]
				//,columnWidth:.5
			}
			
		]
	});
	
	<%--DESARROLLO PRODUCTO 1089------------------------------%>
	
	var prioridadRecord = Ext.data.Record.create([
		{name: 'id'},
		{name : 'codigo'},
		{name: 'descripcion'}
	]);

	var prioridadStore = page.getStore({
		flow: 'expedientejudicial/getDiccionarioPrioridad',
		reader: new Ext.data.JsonReader({
			root: 'prioridad'
		}, prioridadRecord)
	});

	var comboPrioridad = new Ext.form.ComboBox({
		name:'prioridad',
	    hiddenName:'prioridad',
		store: prioridadStore,
		displayField: 'descripcion',
		mode: 'local',
		triggerAction: 'all',
		valueField: 'codigo',
		emptyText:'----',
		labelStyle:labelStyle,
		allowBlank: true,
		autoSelect: true,
		fieldLabel: '<s:message code="procedimientos.edicion.prioridad" text="**Prioridad" />'
		});
		
	
	comboPrioridad.on('afterrender', function(combo) {
		prioridadStore.webflow();
	});
	
	prioridadStore.on('load',function(ds,records,o){
			comboPrioridad.setValue(records[2].data.codigo);
  	});

	
	var preparacionRecord = Ext.data.Record.create([
		{name: 'id'},
		{name : 'codigo'},
		{name: 'descripcion'}
	]);

	var preparacionStore = page.getStore({
		flow: 'expedientejudicial/getDiccionarioPreparacion',
		reader: new Ext.data.JsonReader({
			root: 'preparacion'
		}, preparacionRecord)
	});

	var comboPreparacion = new Ext.form.ComboBox({
		name:'preparacion',
	    hiddenName:'preparacion',
		store: preparacionStore,
		displayField: 'descripcion',
		mode: 'local',
		triggerAction: 'all',
		valueField: 'codigo',
		emptyText:'----',
		labelStyle:labelStyle,
		allowBlank: true,
		fieldLabel: '<s:message code="procedimientos.edicion.preparacion" text="**Preparacion" />'
	});
	
	comboPreparacion.on('afterrender', function(combo) {
		preparacionStore.webflow();
	}); 
	
	preparacionStore.on('load',function(ds,records,o){
			comboPreparacion.setValue(records[2].data.codigo);
   	});
	
	var comboTipoAccionPropuestaAIniciar = new Ext.form.ComboBox({
	    name:'tipoAccionPropuesta'
	    ,hiddenName:'tipoAccionPropuesta'
	    ,store: optionsTipoActuacionStore
	    ,displayField:'descripcion'
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,emptyText:'----'
	    ,valueField: 'codigo'
	    ,labelStyle:labelStyle
	    ,allowBlank: true
		,fieldLabel : '<s:message code="procedimientos.edicion.accionPropuesta" text="**Tipo acci�n propuesta a iniciar" />'
	});
	
	var tipoProcedimientoRecord2 = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsTipoProcedimientoIniciarStore =	page.getStore({
	       flow: 'procedimientos/buscarTiposProcedimiento'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'tiposProcedimiento'
	    }, tipoProcedimientoRecord)
	       
	});
	
	comboTipoAccionPropuestaAIniciar.on('select',function(){
		var codigo=comboTipoAccionPropuestaAIniciar.getValue();
		optionsTipoProcedimientoIniciarStore.webflow({codigo:codigo})
		comboTipoActuacionPropuestaAIniciar.reset();
		comboTipoActuacionPropuestaAIniciar.enable();
	});
	
	var comboTipoActuacionPropuestaAIniciar = new Ext.form.ComboBox({
	    name:'tipoActuacionPropuesta',
	    hiddenName:'tipoActuacionPropuesta',
	    store: optionsTipoProcedimientoIniciarStore,
	    displayField: 'descripcion',
	    mode: 'local',
	    triggerAction: 'all',
	    emptyText:'----',
		valueField: 'codigo',
		labelStyle:labelStyle,
		allowBlank: true,
		fieldLabel : '<s:message code="procedimientos.edicion.actuacionPropuesta" text="**Tipo actuaci�n propuesta a iniciar" />'
	});
	
    var chkBoxPreturnado = new Ext.form.Checkbox({
    	name:'preturnado'
    	,labelStyle:labelStyle
        ,fieldLabel:'<s:message code="procedimientos.edicion.preTurnado" text="**Pre-turnar letrado" />'
    });
	
	var chkBoxOrdinario = new Ext.form.Checkbox({
		name:'turnadoOrdinario'
		,labelStyle:labelStyle
		,checked:true
		,value: true
        ,fieldLabel:'<s:message code="procedimientos.edicion.turnadoOrdinario" text="**Turnado ordinario" />'
    });
    
	var fieldSetPco =new Ext.form.FieldSet({
		title:'<s:message code="procedimientos.edicion.adicionalPCO" text="**Adicional PCO" />'
		,autoHeight:true
		<c:if test="${litigar==true}">
		,hidden: false
		</c:if>
		<c:if test="${litigar==false}">
		,hidden: true
		</c:if>
		,height:280
		,autoShow:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:20px;margin-right:5px;'
				,autoHeight:true
				,autoWidth:true
				,items:
				[
					comboPrioridad
					,comboPreparacion
					,comboTipoAccionPropuestaAIniciar
					,comboTipoActuacionPropuestaAIniciar
					,chkBoxOrdinario
					,chkBoxPreturnado
				]
				,style : 'margin-right:10px'
			}
		]
	});
	
	var motivoRecord = Ext.data.Record.create([
		{name: 'id'},
		{name : 'codigo'},
		{name: 'descripcion'}
	]);
	
	var motivoStore = page.getStore({
		flow: 'mejactuacion/getDiccionarioMotivos',
		reader: new Ext.data.JsonReader({
			root: 'motivos'
		}, motivoRecord)
	});
	
	var comboMotivo = new Ext.form.ComboBox({
		name:'motivo',
	    hiddenName:'motivo',
		store: motivoStore,
		displayField: 'descripcion',
		mode: 'local',
		triggerAction: 'all',
		valueField: 'codigo',
		labelStyle:labelStyle,
		allowBlank: true,
		fieldLabel: '<s:message code="procedimientos.edicion.motivo" text="**Motivo" />'
	});
	
	comboMotivo.on('afterrender', function(combo) {
		motivoStore.webflow();
	});
	
	var observaciones = new Ext.form.TextArea({
		name:'observaciones',
		hideLabel:true
		,labelSeparator: ''
		,fieldLabel:''
		,width: 400
		,height: 100
		,maxLength: 500
		,maxLengthText: 500
		,readOnly: false
		,labelStyle: ''
		,value:''
		,allowBlank:true
	});
	
	var fieldSetLitigar =new Ext.form.FieldSet({
		title:'<s:message code="procedimientos.edicion.adicionalLitigar" text="**Adicional no litigar" />'
		//,autoHeight:true
		,height:180
		<c:if test="${litigar==false}">
		,hidden: false
		</c:if>
		<c:if test="${litigar==true}">
		,hidden: true
		</c:if>
		,autoShow:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:20px;margin-right:5px;'
				,autoHeight:true
				,autoWidth:true
				,items:
				[
					comboMotivo
					,observaciones
				]
				,style : 'margin-right:10px'
				
			}
			
		]
	});
	
	<%--
	tipoActuacion.on('select',function(){
		debugger;
		var codigo=tipoActuacion.getValue();
		optionsTipoProcedimientoStore.webflow({codigo:codigo})
		comboTipoProcedimiento.reset();
		comboMotivo.reset();
		observaciones.reset();
		comboPrioridad.reset();
		comboPreparacion.reset();
		comboTipoAccionPropuestaAIniciar.reset();
		comboTipoActuacionPropuestaAIniciar.reset();
		debugger;
		if(prioridadStore.getTotalCount() > 0){
			comboPrioridad.setValue(prioridadStore.getAt(2).data.codigo);
		}
		if(preparacionStore.getTotalCount()>0){
			comboPreparacion.setValue(preparacionStore.getAt(2).data.codigo);
		}
		chkBoxOrdinario.setValue(true);
		chkBoxPreturnado.reset();
		var el = Ext.getCmp("tmp");
		fieldSetLitigar.hide();
		if(tipoActuacion.getValue() == "PCO"){
			el.setVisible(true);
			fieldSetPco.setVisible(true);
			fieldSetPco.show();
		}else{
			el.setVisible(false);
			fieldSetPco.hide();
		}
	});
	--%>
	
	<%--
	comboTipoProcedimiento.on('select',function(){
		debugger;
		var codigo=comboTipoProcedimiento.getValue();
		var el = Ext.getCmp("tmp");
		if(comboTipoProcedimiento.getValue() == "NOLIT"){
			el.setVisible(true);
			fieldSetLitigar.show();
		}else{
			if(tipoActuacion.getValue() != "PCO"){
				el.setVisible(false);
				comboMotivo.reset();
			}
			fieldSetLitigar.hide();
			observaciones.reset();
		}
	});
	 --%>
	
	var seleccionado = chkBoxOrdinario.getValue();
	if(seleccionado){
		chkBoxPreturnado.disable();
		chkBoxPreturnado.reset();
	} 
	chkBoxOrdinario.on('check',function(){
		if (chkBoxOrdinario.getValue()== true)
		{
			chkBoxPreturnado.disable();
			chkBoxPreturnado.setValue(null);
		}else{
			chkBoxPreturnado.enable();
		}
	});
	chkBoxPreturnado.on('check',function(){
		if (chkBoxPreturnado.getValue()== true)
		{
			chkBoxOrdinario.setValue(null);
			chkBoxOrdinario.disable();
		}else{
			chkBoxOrdinario.enable();
		}
	});
	<%----------------------------------------------------- --%>

	var fieldSetActuacion =new Ext.form.FieldSet({
		title:'<s:message code="procedimientos.edicion.tipoactuacion" text="**Tipo Actuacion" />'
		//,autoHeight:true
		,height:180
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:20px;margin-right:5px;'
				,autoHeight:true
				,autoWidth:true
				,items:
				[
					tipoActuacion
					,comboTipoProcedimiento
					,comboTipoReclamacion
					//,asuntoLabel
					,comboAsuntos
					,comboPropuestas
					//,idAsuntoH
					,seleccionPersonas
					,seleccionContratos
					,idProcedimiento
					,enConformacionHidden
					,sOrigVenc
					,sOrigNoVenc
					,codTipoAsu
					,litigarHidden
				]
				,style : 'margin-right:10px'
				
			}
			
		]
	});
	
	
	/**
	*Funci�n para inicializar los elementos clientes seleccionados.
	*/
	var incializarSeleccionados = function(clientes){
		for (var i=0; i < clientes.length; i++){
			<c:if test="${appProperties.runInSelenium==false}">
			if(clientes[i].asiste==true){
			</c:if>
				personasSeleccionadas[personasSeleccionadas.length] = clientes[i].id;
				if (personasSeleccionadasString != ""){
					personasSeleccionadasString += "-";
				}
				personasSeleccionadasString += clientes[i].id;
			<c:if test="${appProperties.runInSelenium==false}">
			}
			</c:if>
		}
	}
	
	var checkColumn = new Ext.grid.CheckboxSelectionModel({
  		singleSelect: false,
  		header:''
        <app:test id="checkboxGrid" addComa="true" />  		
	});
	
    var clientesRowselectListener = function (el, rowIndex, r){
    	r.data.asiste = true;
		Ext.fly(this).addClass('x-grid3-row-checker-on');
    };
    
    var clientesRowDeselectListener = function (el, rowIndex, r){
    	r.data.asiste = false;
		Ext.fly(this).removeClass('x-grid3-row-checker-on');
    };
	
	checkColumn.addListener('rowselect', clientesRowselectListener);
	checkColumn.addListener('rowdeselect', clientesRowDeselectListener);

	var clientesIncluirCm = new Ext.grid.ColumnModel([
		{ dataIndex : 'id', hidden:true, fixed:true }
		,{header : '<s:message code="procedimientos.edicion.grid.nombre" text="**Nombre"/>',width: 175, dataIndex : 'nombre' }
		,{header : '<s:message code="procedimientos.edicion.grid.apellido1" text="**Apellido1"/>',width: 125, dataIndex : 'apellido1' }
		,{header : '<s:message code="procedimientos.edicion.grid.apellido2" text="**Apellido2"/>',width: 125, dataIndex : 'apellido2' }
		//,{header : '<s:message code="procedimientos.edicion.grid.tipoIntervencion" text="**Tipo Intervenci�n"/>',width: 125, dataIndex : 'tipoIntervencion' }
		,{header : '<s:message code="procedimientos.edicion.grid.totaldeudairr" text="**Deuda Irr"/>',width: 125, dataIndex : 'deudaIrregular', renderer: app.format.moneyRenderer, align:'right' }
		,{header : '<s:message code="procedimientos.edicion.grid.totalsaldo" text="**totalsaldo"/>',width: 125, dataIndex : 'totalSaldo', renderer: app.format.moneyRenderer, align:'right' }
		,checkColumn
	]);
	
	<%--
	var clientesIncluirGrid = new Ext.grid.GridPanel({
		store : clientesIncluirStore
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,title:'<s:message code="procedimientos.edicion.grid.clientes.titulo" text="**Clientes a incluir" />'
		<app:test id="clientesIncluirGrid" addComa="true" />
		,cm : clientesIncluirCm
		,style:'padding-right:10px;padding-top:10px'
		//,plugins: checkColumn
		,clicksToEdit:1
		,width:650
		,height : 130
		,doLayout: function() {
			  var parentSize = panelEdicion.getSize(true); 
			  this.setWidth(parentSize.width-10);//el  -10 es un margen
			  Ext.grid.GridPanel.prototype.doLayout.call(this);
		}
		,autoWidth: true
	});
	--%>
	var clientesIncluirGrid = app.crearEditorGrid(clientesIncluirStore, clientesIncluirCm,{
		title: '<s:message code="procedimientos.edicion.grid.clientes.titulo" text="**Clientes a incluir" />'
		,sm: checkColumn
		,cls: 'cursor_pointer'
		,style:' padding-right:10px'
		,iconCls: 'icon_personas'
		,height: 130
		,height: 650
		,parentWidth:885
		,loadMask: true
		,viewConfig: {forceFit: true}
		,autoExpand: true
		,clicksToEdit: 1
		,style: 'padding-top:10px'
		,autoWidth: true
	});	
	
	//incializarSeleccionados(clientesIncluir);
	seleccionPersonas.setValue(personasSeleccionadasString);
	
	var habilitaComponentes = function(estado)
	{
		saldoARecuperar.setDisabled(!estado);
		recuperacion.setDisabled(!estado);
		meses.setDisabled(!estado);
		
		tipoActuacion.setDisabled(!estado);
		comboTipoProcedimiento.setDisabled(!estado);
		comboTipoReclamacion.setDisabled(!estado);
	}
	
	var actualizarPersonasSeleccionadas = function() {
		var sPersonas = "";
		for (var p=0;p < clientesIncluirStore.data.length; p++) {
			if (clientesIncluirStore.getAt(p).data.asiste) {
				if (sPersonas!="")
					sPersonas += "-";
				sPersonas += clientesIncluirStore.getAt(p).id;
			}
		}
		seleccionPersonas.setValue(sPersonas);
	}
	
	var actualizarContratosSeleccionados = function() {
		
        var contratosSel = "";
        for (var c=0;c < contratosStore.data.length; c++) {
        	if (contratosStore.getAt(c).data.seleccionado) {
        		if (contratosSel!="")
        			contratosSel += ",";
        		contratosSel += contratosStore.getAt(c).data.idCex;
        	}
        }
        
        seleccionContratos.setValue(contratosSel);	
	}	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//habilitaComponentes(true);
			//VALIDACIONES
			var errores="";
			if(observaciones.getValue() != null){
				if(observaciones.getValue().length>500){
					errores+="<br>El campo observaciones no puede ser tan largo";
				}
			}
			if(!comboTipoProcedimiento.validate())
				errores+="<br>Tipo de procedimiento obligatorio";
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
			<%--
			//Esta validaci�n se debe realizar en servidor
			if ('${litigar}'=='false') {
				if (!confirmarContratosSelTienenPersonasSel()) {
					errores+="<br>Algunos contratos seleccionados no tienen personas relacionadas seleccionadas";
				}
			}
			--%>
			
			if(errores!=""){
				Ext.Msg.alert("Errores",errores);
				return;
			}
			//FIN VALIDACIONES
			
			actualizarContratosSeleccionados();
			actualizarPersonasSeleccionadas();
			
			page.submit({
				eventName : 'updateProcedimiento'
				,formPanel : panelEdicion
				,success : function(){ 
						page.fireEvent(app.event.DONE)
					 }
			});

			//habilitaComponentes(false);
		}
	});
	
	var confirmarContratosSelTienenPersonasSel = function() {
		//Recorremos todos los contratos
		contratosStore.commitChanges();
		clientesIncluirStore.commitChanges();
		for (var ci = 0; ci < contratosStore.data.length ; ci++) {
			//Si el contrato esta seleccionado
			if (contratosStore.getAt(ci).data.seleccionado) {
				var perEncontrada = false;
				for (var p = 0; p < clientesIncluirStore.data.length; p++) {
					if (clientesIncluirStore.getAt(p).data.cntId == contratosStore.getAt(ci).data.id && clientesIncluirStore.getAt(p).data.asiste) {
						perEncontrada = true;
						break;
					}
				}
				//Si no hemos encontrado persona para este contrato devolvemos false
				if (!perEncontrada)
					return false;
			}
		}
		
		//Si para todos los contratos hemos encontrado personas
		return true;
	};

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.webflow({
				flow: 'asuntos/borraAsunto'
				,eventName: 'borrarAsunto'
				,params:{idAsunto: '${idAsunto}'}
				,success: function() {
					page.fireEvent(app.event.CANCEL);
				}
			});
		}
	});
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : false
		,autoScroll: true
		,height: 550
		,autoWidth:true
		,bodyStyle : 'padding:5px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,viewConfig : { columns : 2 }
				,defaults :  {height:200,style:'padding:5px'}
				,items : [
					{
						items :fieldSetActuacion
						 ,width:480
						 ,border:false
					}
					,{
						items : fieldSetEstimacion
						 ,width:370 
						 ,border:false
					}
					,{
						border:false
						,width:480
						,items:[fieldSetPco, fieldSetLitigar]
						,hidden: false
						,id:'tmp'
						,autoHeight:true
					} 
				]
			}
			,{
				border:false
				,items:contratosGrid
			}
			
			,{
				border:false
				,items: clientesIncluirGrid
			}
		]
		,bbar:[btnGuardar,btnCancelar]
	});

	page.add(panelEdicion);
	
	Ext.onReady(function(){
		<c:if test="${litigar}">
		tipoActuacion.setValue(prcPCO);
		tipoActuacion.fireEvent('select');
		comboTipoAccionPropuestaAIniciar.setValue(ejeCamb);
		comboTipoAccionPropuestaAIniciar.fireEvent('select');
		</c:if>
		<c:if test="${litigar==false}">
		tipoActuacion.setValue(cntBloq);
		tipoActuacion.fireEvent('select');
		</c:if>
	});
	
</fwk:page>