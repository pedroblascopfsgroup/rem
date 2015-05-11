<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

 	var rendererOrdm = function(value, metaData, record, rowIndex, colIndex, store){ 
        if (value) {
            return value + '&ordm;';
        } else {
            return '';
        }
        return '';
    };
    
	<pfs:hidden name="codTipoReparto" value="${ddTipoReparto.codigo}"/>
	<pfs:hidden name="txtTipoReparto" value="${ddTipoReparto.descripcion}"/>
	<pfs:hidden name="idSubCartera" value="${idSubCartera}"/>
	var disable = '${disable}';
	<pfs:hidden name="REP_ESTATICO" value="${REP_ESTATICO}"/>
	<pfs:hidden name="REP_DINAMICO" value="${REP_DINAMICO}"/>
		
	
		
	<pfsforms:textfield name="txtNombre"
		labelKey="plugin.recobroConfig.SubCarRepEst.Nombre" label="**Nombre"
		value="${subCartera.nombre}" readOnly="false" width="190" obligatory="true"/>
		
	txtNombre.maxLength=50;	
	
	<pfsforms:numberfield name="txtParticion"
		labelKey="plugin.recobroConfig.SubCarRepEst.Particion" label="**% Particion"
		value="${subCartera.particion}" obligatory="true"/>
		
	txtNombre.on('change',function(){
		btnGuardarValidacion.setDisabled(false);
	});
	
	txtParticion.on('change',function(){
		btnGuardarValidacion.setDisabled(false);
	});
		
	txtParticion.maxValue=100;	
	
	var panelModelo = new Ext.form.FieldSet({
			autoHeight:true
			,width:650
			//,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="plugin.recobroConfig.SubCarRepEst.panelModelo.title" text="**Datos del modelo de {0}" arguments="'+txtTipoReparto.getValue()+'"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:320}
		    ,items : [{items:[txtNombre]},
					  {items:[txtParticion]}
					 ]
		});
	
	var validarForm = function(){
		if (txtNombre.getActiveError()!=''){
			return '<s:message code="plugin.recobroConfig.SubCar.Requerido.nombre" text="**Debe introducir un nombre para el reparto"/>';
		}
		if (txtParticion.getActiveError()!=''){
			return '<s:message code="plugin.recobroConfig.SubCar.Requerido.particion" text="**Debe introducir el porcentaje de la cartera que queda asignado a este reparto"/>';
		}
		if (subCarAgenciasDS.data.length <= 0) {
			return '<s:message code="plugin.recobroConfig.SubCar.Requerido.numeroAgencias" text="**Debe introducir al menos una agencia"/>';
		}
		
		//Validar los porcentajes de los grids
		<c:if test="${ddTipoReparto.codigo == REP_ESTATICO}">
			var porcentaje = 0;
			for (i=0;i < subCarAgenciasDS.getCount();i++) {
				porcentaje += subCarAgenciasDS.getAt(i).get('coeficiente');
			}
			if (porcentaje > 100) {
				return '<s:message code="plugin.recobroConfig.SubCarRepEst.coeficienteMayor" text="**La suma de los coeficientes de reparto es mayor al 100%"/>';
			}
			if (porcentaje < 100) {
				return '<s:message code="plugin.recobroConfig.SubCarRepEst.coeficienteMenor" text="**La suma de los coeficientes de reparto de las agencias no cubre el 100% de la subcartera"/>';
			}
		</c:if>
		<c:if test="${ddTipoReparto.codigo == REP_DINAMICO}">
			var porcentaje = 0;
			for (i=0;i < rankingStore.getCount();i++) {
				porcentaje += rankingStore.getAt(i).get('porcentaje');
			}
			if (porcentaje > 100) {
				return '<s:message code="plugin.recobroConfig.SubCarRepEst.rankingMayor" text="**La suma de los coeficientes de reparto del ranking es mayor al 100%"/>';
			}
			if (porcentaje < 100) {
				return '<s:message code="plugin.recobroConfig.SubCarRepEst.rankingMenor" text="**La suma de los coeficientes de reparto no cubre el 100% del ranking"/>';
			}
		</c:if>
		return '';
	};
	
	
	var subCarAgencias = Ext.data.Record.create([
		{name:'id'}
		,{name:'idAgencia'}
		,{name:'NomAgencia'}		
		,{name:'coeficiente'}		
	]);
	
	var subCarAgenciasDS = page.getStore({
		eventName : 'subCarAgencias'
		,flow:'recobroesquema/buscaSubCarterasAgencias'
		,reader: new Ext.data.JsonReader({
			root: 'subCarAgencias'
		}, subCarAgencias)
		//,remoteSort : true
	});
	
	subCarAgenciasDS.webflow({idSubCartera: idSubCartera.getValue()});
	
	var subCarAgenciasCM = new Ext.grid.ColumnModel([
	{header: '<s:message code="plugin.recobroConfig.SubCarRepEst.columnaSubCartera.id" text="**id"/>',
		dataIndex: 'id', sortable: true, hidden: true
	}, {header: '<s:message code="plugin.recobroConfig.SubCarRepEst.columnaSubCartera.idAgencia" text="**id Agencia"/>',
		dataIndex: 'idAgencia', sortable: true, hidden: true
	}, {header : '<s:message code="plugin.recobroConfig.SubCarRepEst.columnaSubCartera.nombre" text="**Nombre" />', 
		dataIndex : 'NomAgencia' , width: 280, sortable:true
	}<c:if test="${ddTipoReparto.codigo == REP_ESTATICO}">, {header : '<s:message code="plugin.recobroConfig.SubCarRepEst.columnaSubCartera.coeficiente" text="**Coeficiente reparto" />', 
		dataIndex : 'coeficiente' , width: 200, sortable:true
	}</c:if>
	]);
	
	
	
	var btnDesasociar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.SubCarReparto.Desasociar" text="**Desasociar proveedor" />'
		,iconCls : 'icon_providerDel'
		,handler : function(){
			if (gridSubCarAgencias.getSelectionModel().getCount()>0){
				var s = gridSubCarAgencias.getSelectionModel().getSelected();
	            gridSubCarAgencias.stopEditing();
	            subCarAgenciasDS.remove(s);
	            gridSubCarAgencias.startEditing(0, 0);
	            
	            <c:if test="${ddTipoReparto.codigo == REP_DINAMICO}">
		            rankingGrid.stopEditing();
		            rankingStore.removeAt(rankingStore.getCount()-1);
		            rankingGrid.startEditing(0,0);
		        </c:if>
		        
		        btnGuardarValidacion.setDisabled(false);
		     } else {
		     	Ext.Msg.confirm('<s:message code="plugin.recobroConfig.SubCarReparto.Desasociar" text="**Desasociar proveedor" />', '<s:message code="plugin.recobroConfig.SubCarReparto.avisoSeleccionarProveedor" text="**Debe seleccionar el proveedor a desasociar del reparto"/>', function(btn){
		   				callCancelar(btn);
					});
		     }
		 }
	});
	
	var gridSubCarAgencias = new Ext.grid.EditorGridPanel({
        store: subCarAgenciasDS
        ,cm: subCarAgenciasCM
        ,title: '<s:message code="plugin.recobroConfig.SubCarRepEst.gridSubCarAgencias.title" text="**Proveedores"/>'
        //,stripeRows: true
        ,height: 200
        ,width: (codTipoReparto.getValue() == REP_ESTATICO.getValue()) ? 625 : 295
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 0px;'
		,bodyStyle : 'padding:0px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,clicksToEdit: 1
		,bbar:[btnDesasociar]
    });	
	
	gridSubCarAgencias.on('rowclick', function(grid, rowIndex, e){
    	var rec = grid.getStore().getAt(rowIndex);
    	cmbAgencias.setValue(rec.get('idAgencia'));
    	txtCoeficiente.setValue(rec.get('coeficiente'));
    	
    });
    
	//****GRID RANKING*****//
	var rankingRecord = Ext.data.Record.create([
		{name:'id', type:'Float'}
		,{name:'posicion', type:'int'}
		,{name:'porcentaje', type:'int'}
	]);
	
	var rankingStore = page.getStore({
		eventName : 'subCarRanking'
		,flow:'recobroesquema/buscaSubCarterasRanking'
		,reader: new Ext.data.JsonReader({
			root: 'subCarRanking'
		}, rankingRecord)
	});
	
	<c:if test="${ddTipoReparto.codigo == REP_DINAMICO}">
	
	var porcentaje_edit = new Ext.form.NumberField({
		maxValue:100,
		minValue:0,
		decimalPrecision:0,
		selectOnFocus:true
	});
	
	porcentaje_edit.on('change', function(){
		btnGuardarValidacion.setDisabled(false); 
	});	
	
    
	var rankingCM  = new Ext.grid.ColumnModel([
		{header:'<s:message code="plugin.recobroConfig.SubCarRepEst.gridRanking.posicion" text="**Posición"/>',width:80, dataIndex: 'posicion',fixed:true,renderer:rendererOrdm},
		{header:'<s:message code="plugin.recobroConfig.SubCarRepEst.gridRanking.porcentaje" text="**% Reparto"/>',width:200,dataIndex:'porcentaje', editor: porcentaje_edit}
	]);
	
	var rankingGrid = new Ext.grid.EditorGridPanel({
		id: 'rankingGrid',
		title:'<s:message code="plugin.recobroConfig.SubCarRepEst.gridRanking.title" text="**Reparto según ranking"/>',
		store: rankingStore,
		cm: rankingCM,
		width: 295,
		height: 200
	});
     
    rankingStore.webflow({idSubCartera: idSubCartera.getValue()});
    
	//***FIN GRID RANKING***//	
	</c:if>
	
	<pfsforms:ddCombo name="cmbAgencias"
	labelKey="plugin.recobroConfig.SubCarRepEst.columnaSubCartera.nombre" label="**Nombre"
	value="" dd="${agencias}" width="200" propertyCodigo="id" propertyDescripcion="nombre"/>

	<pfsforms:numberfield name="txtCoeficiente"
	labelKey="plugin.recobroConfig.SubCarRepEst.columnaSubCartera.coeficiente" label="**Coeficiente Reparto"
	value="0" />
	
	txtCoeficiente.maxValue=100;
	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,disabled : 'true'
		,handler :  function(){
			if (validarForm()==''){
    			var parms = {};
    			parms.idCarteraEsquema='${idCarteraEsquema}';
    			parms.idTipoReparto='${ddTipoReparto.id}';    			
    			parms.idSubCartera=idSubCartera.getValue();
    			parms.nomSubCartera=txtNombre.getValue();
    			parms.particion=txtParticion.getValue();
    			parms.reparto=getArrayParam(subCarAgenciasDS, rankingStore);   			
 
    			page.webflow({
						flow: 'recobroesquema/saveSubCartera'
						,params: parms
						,success : function(){ 
							page.fireEvent(app.event.DONE);
						}
					});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />'
				,validarForm());
			}
		}
	});		
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});
	
	var validarAsociacion=function(){
		if (cmbAgencias.getValue() == ''){
			var msg = '<s:message code="plugin.recobroConfig.SubCarRepEst.gridSubCarAgencias.camposObligatorios-dinamico" text="**Debe rellenar la agencia" />'; 
			<c:if test="${ddTipoReparto.codigo == REP_ESTATICO}">
				msg ='<s:message code="plugin.recobroConfig.SubCarRepEst.gridSubCarAgencias.camposObligatorios" text="**Debe rellenar la agencia y coeficiente de reparto" />';  
			</c:if>
			return msg
		} 
		<c:if test="${ddTipoReparto.codigo == REP_ESTATICO}"> 
			if (txtCoeficiente.getActiveError()!='') {
				return txtCoeficiente.getActiveError();
			}
		</c:if>
		return '';
	}
	
	var btnAsociar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.SubCarReparto.Asociar" text="**Asociar proveedor" />'
		,iconCls : 'icon_providerAdd'
		,handler : function(){
			if (validarAsociacion()!='') {
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />'
				,validarAsociacion());
			} else {
				var record = subCarAgenciasDS.find('idAgencia', cmbAgencias.getValue());
				if (record != -1) {
					<c:if test="${ddTipoReparto.codigo == REP_ESTATICO}">
					Ext.Msg.confirm('<s:message code="app.aviso" text="**Aviso" />',
					'<s:message code="plugin.recobroConfig.SubCarRepEst.gridSubCarAgencias.agenciaOverwrite" text="**¿Seguro que desea reemplazar el coerficiente de la agencia \"{0}\"?"  arguments="'+cmbAgencias.getRawValue()+'"/>', function(btn){				
		  				if (btn == "yes") {
			  				var rec = subCarAgenciasDS.getAt(record);
							rec.set('coeficiente',txtCoeficiente.getValue());
							rec.commit();
							
							cmbAgencias.reset();
		    				txtCoeficiente.reset();	
		    				
		    				btnGuardarValidacion.setDisabled(false);
						}
					});
					</c:if>
					<c:if test="${ddTipoReparto.codigo == REP_DINAMICO}">
					Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />',
					'<s:message code="plugin.recobroConfig.SubCarRepEst.gridSubCarAgencias.agenciaExiste" text="**Ya existe la agencia \"{0}\""  arguments="'+cmbAgencias.getRawValue()+'"/>');
					</c:if>
		        } else {
			 		var rowCarAgen = gridSubCarAgencias.getStore().recordType;
		            var p = new rowCarAgen({	 
							idAgencia: cmbAgencias.getValue()			
							,NomAgencia: cmbAgencias.getRawValue()
							,coeficiente: txtCoeficiente.getValue()
		            });
		            
	            
		            gridSubCarAgencias.stopEditing();
		            subCarAgenciasDS.insert(0, p);
		            gridSubCarAgencias.startEditing(0, 0);
			    
			    	<c:if test="${ddTipoReparto.codigo == REP_DINAMICO}">        
		            var rowRanking = rankingGrid.getStore().recordType;
		            var p2 = new rowRanking({
		            		posicion: subCarAgenciasDS.getCount()
		            		,porcentaje:0
		            	});

					rankingGrid.stopEditing();
					rankingStore.addSorted(p2);
					rankingGrid.startEditing(0,0);		            	
					</c:if>
			        
			        cmbAgencias.reset();
				    txtCoeficiente.reset();
				    
				    btnGuardarValidacion.setDisabled(false);
				    	
		        }
		        
	        } 
		 }
	});
	
	
	
	
	function getArrayParam(store, storeRanking){
		var storeValues=[];
		var allRecords = store.getRange();
		for (i=0;i < allRecords.length;i++){
			var rec = allRecords[i];
			storeValues[i] = rec.data;
		}
		var myArrayParam = new MyArrayParam();
		myArrayParam.subCarAgenItems = storeValues;
		
		storeValues=[];
		allRecords = storeRanking.getRange();
		for (i=0;i < allRecords.length;i++){
			var rec = allRecords[i];
			storeValues[i] = rec.data;
		}
		myArrayParam.subCarRankingItems = storeValues;
		
		return Ext.encode(myArrayParam);
	} 
	
	MyArrayParam = function() {
		var subCarAgenItems;
		var subCarRankingItems;
	}
	
	var panelProveedores = new Ext.form.FieldSet({
			autoHeight:true
			,width:650
			,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="plugin.recobroConfig.SubCarRepEst.gridSubCarAgencias.titleFieldSet" text="**Añadir Proveedores"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:330,style:'padding:0 0 0 10'}
		    ,items : [{style:'padding:10 0 0 10',items:[cmbAgencias]}
		    		<c:if test="${ddTipoReparto.codigo == REP_ESTATICO}">,{items:[txtCoeficiente]}</c:if>
		    		<c:if test="${ddTipoReparto.codigo == REP_DINAMICO}">,{html:'&nbsp;',border:false}</c:if>
		    		  ,{colspan:2,width:680,items:[btnAsociar]}
		    		  <c:if test="${ddTipoReparto.codigo == REP_ESTATICO}">
		    		  ,{colspan:2,width:680,items:[gridSubCarAgencias]}
		    		  </c:if>
		    		  <c:if test="${ddTipoReparto.codigo == REP_DINAMICO}">
		    		  ,{items:[gridSubCarAgencias]}
		    		  ,{style:'padding:0',items:[rankingGrid]}
		    		  </c:if>
					 ]
		});
	
	var panelEdicion = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:1}
				,border:false
				//,bodyStyle:'padding:5px;cellspacing:10px;'
				,defaults : {xtype : 'fieldset',width : 680, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
				,items:[{items: [panelModelo,panelProveedores]}]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		
	
	
	if(disable){
		//panelModelo.disable();
		txtNombre.disable();
		txtParticion.disable();
		//panelProveedores.disable();
		gridSubCarAgencias.enable();
		txtCoeficiente.disable();
		btnAsociar.disable();
		cmbAgencias.disable();
		btnDesasociar.disable();
	}
	
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_REPARTOSUBCARTERAS">
		btnGuardarValidacion.show();
		if(disable){
			btnGuardarValidacion.hide();
		}
	</sec:authorize>	
	
	page.add(panelEdicion);

</fwk:page>