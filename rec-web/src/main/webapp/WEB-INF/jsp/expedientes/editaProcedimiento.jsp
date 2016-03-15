<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>

	var prcConformacion = '<fwk:const value="es.capgemini.pfs.asunto.model.DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION" />';

	var enConformacion = true;
	<c:if test="${procedimiento!=null}" >
		enConformacion = (${procedimiento.estadoProcedimiento.codigo} == prcConformacion);
	</c:if>

	var enConformacionHidden = new Ext.form.Hidden({
		name:'enConformacion'
		,value:enConformacion
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
		<c:if test="${procedimiento!=null}" >
			,value:'${procedimiento.id}'
		</c:if>
	});
	
	var seleccionPersonas = new Ext.form.Hidden({
		name:'seleccionPersonas'
	});
		
	var seleccionContratos = new Ext.form.Hidden({
		name:'seleccionContratos'
	});
	
	var sOrigVenc = new Ext.form.Hidden({
		name:'saldoOriginalVencido'
		,value:'${procedimiento.saldoOriginalVencido}'
	});
	
	var sOrigNoVenc = new Ext.form.Hidden({
		name:'saldoOriginalNoVencido'
		,value:'${procedimiento.saldoOriginalNoVencido}'
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
		<c:if test="${idAsunto==null}">
			,'${procedimiento.asunto.nombre}'
		</c:if>
        ,{labelStyle:labelStyle});

	var idAsuntoH = new Ext.form.Hidden({
		name:'asunto'
		<c:if test="${idAsunto!=null}">
        	,value:'${asunto.id}'
		</c:if>
		<c:if test="${idAsunto==null}">
			,value:'${procedimiento.asunto.id}'
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
			'<s:message code="procedimientos.edicion.saldorecuperacion" text="**Saldo original " />',
			<c:if test="${procedimiento!=null}" >
				'${procedimiento.saldoRecuperacion}',
			</c:if>
			<c:if test="${procedimiento==null}" >
				'',
			</c:if>
			{labelStyle:labelStyleTextField
			<app:test id="saldoARecuperarField" addComa="true" />
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:14
			,readOnly: !enConformacion
			,disabled: !enConformacion
			,autoCreate : {tag: "input", type: "text",maxLength:"14", autocomplete: "off"}}
	)
	
	var recuperacion  = app.creaNumber('recuperacion',
		'<s:message code="procedimientos.edicion.recuperacion" text="**% Recuperacion " />',
		<c:if test="${procedimiento!=null}" >
				'${procedimiento.porcentajeRecuperacion}',
		</c:if>
		<c:if test="${procedimiento==null}" >
			'',
		</c:if>
		{labelStyle:labelStyleTextField
		,style:style
		,allowDecimals: false
		,allowNegative: false
		,maxLength:3
		,readOnly: !enConformacion
		,disabled: !enConformacion
		,autoCreate : {tag: "input", type: "text",maxLength:"3", autocomplete: "off"}}
	)
	
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
		<c:if test="${procedimiento!=null}" >
				,value:'${procedimiento.plazoRecuperacion}'
		</c:if>
		
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
		<c:if test="${idAsunto==null}">
			<c:if test="${procedimiento!=null}" >
				,value:'${procedimiento.asunto.id}'
			</c:if>
		</c:if>
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
		}
	});
	
	optionsPropuestasStore.on('load', function(){
	  optionsPropuestasStore.add(new optionsPropuestasStore.recordType({
	    fechaPropuesta: '',
	    solicitante: '',
	    idAcuerdo: null,
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
		,fieldLabel : '<s:message code="procedimientos.edicion.tipoactuacion" text="**Tipo" />'
		<c:if test="${procedimiento!=null}" >
			,value:'${procedimiento.tipoActuacion.codigo}'
		</c:if>
	    //,value : 'actual'
	});
	

	//Si no puede modificar el valor pq no está en conformación lo revertimos
	tipoActuacion.on('change', function(){
		if (!enConformacion)
			tipoActuacion.setValue('${procedimiento.tipoActuacion.codigo}');
		
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
				,labelStyle:labelStyle
				,editable: false
				,disabled: !enConformacion
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

	
	//Si no puede modificar el valor pq no está en conformación lo revertimos
	comboTipoProcedimiento.on('change', function(){
		if (!enConformacion)
			comboTipoProcedimiento.setValue('${procedimiento.tipoProcedimiento.codigo}');
	});

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
				<c:if test="${procedimiento!=null}" >
					,value:'${procedimiento.tipoReclamacion.codigo}'
				</c:if>
	});
	
	//Si no puede modificar el valor pq no está en conformación lo revertimos
	comboTipoReclamacion.on('change', function(){
		if (!enConformacion)
			comboTipoReclamacion.setValue('${procedimiento.tipoReclamacion.codigo}');
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
     	
        contratosSeleccionados = rearmarArray(contratosSeleccionados,record.data['id']);
		cexSeleccionados = rearmarArray(cexSeleccionados,record.data['idCex']);
        contratosSeleccionadosString = armarString(contratosSeleccionados);
        
        //Falta el campo hidden para agregar al fieldSetActuacion
        seleccionContratos.setValue(cexSeleccionados);
        record.set(this.dataIndex, !eval(record.data[this.dataIndex]));
        clientesIncluirStore.webflow({
			contratos:contratosSeleccionadosString,
			idProcedimiento:<c:if test="${procedimiento!=null}">'${procedimiento.id}'</c:if>
		                <c:if test="${procedimiento==null}">'0'</c:if>
		});
		
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
    };
    
    var contratosRowDeselectListener = function (el, rowIndex, r){
		actualizaDatosContratosMarcados(false, r);
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

	contratosStore.webflow({idExpediente:${idExpediente}, idProcedimiento:'${procedimiento.id}'});

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
        ,iconCls:'icon_personas'
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
        clientesIncluirStore.webflow({
			contratos:contratosSeleccionadosString,
			idProcedimiento:<c:if test="${procedimiento!=null}">'${procedimiento.id}'</c:if>
			                <c:if test="${procedimiento==null}">'0'</c:if>
		});
	};

	contratosStore.on('load', function() {
		inicializarContratosPersonas();
	});

	clientesIncluirStore.on('load', function() {
		personasSeleccionadas = new Array();
		personasSeleccionadasString = '';
		for (var i=0; i < clientesIncluirStore.getTotalCount(); i++){
			if(clientesIncluirStore.getAt(i).data.asiste==true){
				personasSeleccionadas[personasSeleccionadas.length] = clientesIncluirStore.getAt(i).data.id;
				if (personasSeleccionadasString != ""){
					personasSeleccionadasString += "-";
				}
				personasSeleccionadasString += clientesIncluirStore.getAt(i).data.id;
			}
		}
       	seleccionPersonas.setValue(personasSeleccionadasString);
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
				]
				,style : 'margin-right:10px'
				
			}
			
		]
	});
	
	
	/**
	*Función para inicializar los elementos clientes seleccionados.
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
	
	
	var checkColumn = new Ext.grid.CheckColumn({ 
		header : '<s:message code="procedimientos.edicion.grid.incluido" text="**Incluir"/>'
		,width: 100, dataIndex : 'asiste'
        <app:test id="checkboxGrid" addComa="true" />
	});
		
	var clientesIncluirCm = new Ext.grid.ColumnModel([
		{ dataIndex : 'id', hidden:true, fixed:true }
		,{header : '<s:message code="procedimientos.edicion.grid.nombre" text="**Nombre"/>',width: 175, dataIndex : 'nombre' }
		,{header : '<s:message code="procedimientos.edicion.grid.apellido1" text="**Apellido1"/>',width: 125, dataIndex : 'apellido1' }
		,{header : '<s:message code="procedimientos.edicion.grid.apellido2" text="**Apellido2"/>',width: 125, dataIndex : 'apellido2' }
		//,{header : '<s:message code="procedimientos.edicion.grid.tipoIntervencion" text="**Tipo Intervención"/>',width: 125, dataIndex : 'tipoIntervencion' }
		,{header : '<s:message code="procedimientos.edicion.grid.totaldeudairr" text="**Deuda Irr"/>',width: 125, dataIndex : 'deudaIrregular', renderer: app.format.moneyRenderer, align:'right' }
		,{header : '<s:message code="procedimientos.edicion.grid.totalsaldo" text="**totalsaldo"/>',width: 125, dataIndex : 'totalSaldo', renderer: app.format.moneyRenderer, align:'right' }
		,checkColumn
	]);
	
	var clientesIncluirGrid = new Ext.grid.GridPanel({
		store : clientesIncluirStore
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,title:'<s:message code="procedimientos.edicion.grid.clientes.titulo" text="**Clientes a incluir" />'
		<app:test id="clientesIncluirGrid" addComa="true" />
		,cm : clientesIncluirCm
		,style:'padding-right:10px;padding-top:10px'
		,plugins: checkColumn
		,clicksToEdit:1
		,width:650
		,height : 130
		,doLayout: function() {
			  var parentSize = panelEdicion.getSize(true); 
			  this.setWidth(parentSize.width-10);//el  -10 es un margen
			  Ext.grid.GridPanel.prototype.doLayout.call(this);
		}
	});
	
	//incializarSeleccionados(clientesIncluir);
	seleccionPersonas.setValue(personasSeleccionadasString);
	
	var habilitaComponentes = function(estado)
	{
		//if (!enConformacion) return;

		saldoARecuperar.setDisabled(!estado);
		recuperacion.setDisabled(!estado);
		meses.setDisabled(!estado);
		
		tipoActuacion.setDisabled(!estado);
		comboTipoProcedimiento.setDisabled(!estado);
		comboTipoReclamacion.setDisabled(!estado);
	}
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){

			//habilitaComponentes(true);
			
			//VALIDACIONES
			var errores="";
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
			if(errores!=""){
				Ext.Msg.alert("Errores",errores);
				return;
			}
			//FIN VALIDACIONES
			
			page.submit({
				eventName : 'updateProcedimiento'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});

			//habilitaComponentes(false);
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
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
					
				]
			},{
				border:false
				,items:contratosGrid
			}
			
			,{
				border:false
				,items: clientesIncluirGrid
			}
		]
		<c:if test="${pantalla!='seleccionContratos'}" >
			,bbar:[btnGuardar,btnCancelar]
		</c:if>
	});

	page.add(panelEdicion);
</fwk:page>