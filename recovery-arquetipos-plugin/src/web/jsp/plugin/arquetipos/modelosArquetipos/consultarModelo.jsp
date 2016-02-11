<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>


<fwk:page>
	Ext.util.CSS.createStyleSheet("button.icon_subir { background-image: url('../img/plugin/arquetipos/subir.png');}");
	Ext.util.CSS.createStyleSheet("button.icon_bajar { background-image: url('../img/plugin/arquetipos/bajar.png');}");
	Ext.util.CSS.createStyleSheet("button.icon_copiar { background-image: url('../img/plugin/arquetipos/copia.png');}");
	Ext.util.CSS.createStyleSheet("button.icon_liberar { background-image: url('../img/plugin/arquetipos/libera.png');}");
	Ext.util.CSS.createStyleSheet(".icon_arquetipo { background-image: url('../img/plugin/arquetipos/arquetipo.png');}");
		
	
	<pfsforms:textfield name="nombre" labelKey="plugin.arquetipos.modelo.nombre" label="**Nombre" value="${modelo.nombre}" readOnly="true"/>
	<pfsforms:textfield name="descripcion" labelKey="plugin.arquetipos.modelo.descripcion" label="**Descripción" value="${modelo.descripcion}" readOnly="true"/>
	<pfsforms:textfield name="estado" labelKey="plugin.arquetipos.modelo.estado" label="**Estado" value="${modelo.estado}" readOnly="true"/>
	<pfsforms:textfield name="fechaInicioVigencia" labelKey="plugin.arquetipos.modelo.fechaInicioVigencia" label="**Fecha de Inicio de Vigencia" value="" readOnly="true"/>
	<pfsforms:textfield name="fechaFinVigencia" labelKey="plugin.arquetipos.modelo.fechaFinVigencia" label="**Fecha de Fin de Vigencia" value="" readOnly="true"/>
	
	
	fechaInicioVigencia.setValue('<fwk:date value="${modelo.fechaInicioVigencia}" />');
	fechaFinVigencia.setValue('<fwk:date value="${modelo.fechaFinVigencia}" />');
	
	<pfs:defineParameters name="arquetipoParams" paramId="${modelo.id}"/>
	
	var recargar = function (){
		app.openTab('${modelo.nombre}'
					,'modelosArquetipos/ARQconsultarModelo'
					,{id:${modelo.id}}
					,{id:'ModeloRT${modelo.id}'}
				)
	};
	<pfs:buttonedit name="btModificarModelo" 
			flow="plugin/arquetipos/modelosArquetipos/ARQmodificarModelo" 
			parameters="arquetipoParams" 
			windowTitleKey="plugin.arquetipos.modelo.consultar.modificarModelo" 
			windowTitle="**Modificar modelo"
			on_success="recargar"
			/>
	
	
	<c:choose>
	  <c:when test="${modelo.estado.codigo=='3' || modelo.estado.codigo=='4'}">
			<pfs:panel name="datosGeneralesPanel" columns="2" collapsible="false">
				<pfs:items items="nombre, descripcion, estado "/>
				<pfs:items items="fechaInicioVigencia, fechaFinVigencia"/>
			</pfs:panel>
	  </c:when>
	  <c:otherwise>
			<pfs:buttonedit name="btModificarModelo" 
				flow="plugin/arquetipos/modelosArquetipos/ARQmodificarModelo" 
				parameters="arquetipoParams" 
				windowTitleKey="plugin.arquetipos.modelo.consultar.modificarModelo" 
				windowTitle="**Modificar modelo"
				on_success="recargar"/>
				<pfs:panel name="datosGeneralesPanel" columns="2" collapsible="false" bbar="btModificarModelo">
					<pfs:items items="nombre, descripcion, estado "/>
					<pfs:items items="fechaInicioVigencia, fechaFinVigencia"/>
				</pfs:panel>
	  </c:otherwise>
	</c:choose>


	<pfs:defineRecordType name="ArquetiposModeloRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="prioridad"/>
		<pfs:defineTextColumn name="arquetipo"/>
		<pfs:defineTextColumn name="itinerario_nombre"/>
		<pfs:defineTextColumn name="nivel"/>
		<pfs:defineTextColumn name="gestion" />
		<pfs:defineTextColumn name="plazoDisparo" />  
		<pfs:defineTextColumn name="tipoSaltoNivel" /> 
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="columnasArquetipos">
		<pfs:defineHeader dataIndex="prioridad" 
			captionKey="plugin.arquetipos.modelo.consulta.prioridad" caption="**Prioridad" 
			sortable="true" firstHeader="true"/>
		<pfs:defineHeader dataIndex="arquetipo" 
			captionKey="plugin.arquetipos.modelo.nombre" caption="**Nombre" 
			sortable="true" />
		<pfs:defineHeader dataIndex="itinerario_nombre" 
			captionKey="plugin.arquetipos.modelo.consulta.itinerario" 
			caption="**Itinerario" sortable="true" />
		<pfs:defineHeader dataIndex="nivel" captionKey="plugin.arquetipos.modelo.consulta.nivel" caption="**Nivel" 
			sortable="true" />
		<pfs:defineHeader dataIndex="gestion"
			captionKey="plugin.arquetipos.modelo.gestion" caption="**Gestión"
			sortable="true" />
		<pfs:defineHeader dataIndex="plazoDisparo"
			captionKey="plugin.arquetipos.modelo.plazoDisparo" caption="**Plazo de Disparo"
			sortable="true" />
		<pfs:defineHeader dataIndex="tipoSaltoNivel"
			captionKey="plugin.arquetipos.modelo.tipoSaltoNivel" caption="**Tipo Salto Nivel"
			sortable="true" />
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="storeArquetipos" 
		dataFlow="plugin/arquetipos/modelosArquetipos/ARQlistaArquetiposModeloData"
		resultRootVar="arquetiposModelo" 
		recordType="ArquetiposModeloRT" 
		parameters="arquetipoParams"
		autoload="true"
		/>
	
	<pfs:buttonremove name="btEliminar"
		flow="plugin/arquetipos/modelosArquetipos/ARQeliminarArquetipoModelo"
		novalueMsgKey="plugin.arquetipos.modelo.consulta.novalor"
		novalueMsg="**Seleccione un arquetipo de la lista"  
		paramId="idModeloArquetipo"  
		datagrid="gridArquetiposModelo" 
		parameters="arquetipoParams"
		onSuccess="recargar"
		/>
	
	<pfs:buttonnew name="btAdd" 
		flow="plugin/arquetipos/modelosArquetipos/ARQinsertarArquetipoModelo"
		createTitleKey="plugin.arquetipos.modelo.consulta.insertarArquetipo" 
		createTitle="**Insertar Arquetipo"
		parameters="arquetipoParams"
		onSuccess="recargar"
		/>
	
	
	
	<pfs:button name="btSubir" caption="**Subir Prioridad" captioneKey="plugin.arquetipos.modelo.consulta.subir" iconCls="icon_subir">
		if (gridArquetiposModelo.getSelectionModel().getCount()>0){
    			var idArquetipoModelo = gridArquetiposModelo.getSelectionModel().getSelected().get('id'); 
                var parametros = {
                            idArquetipoModelo : idArquetipoModelo
				}
    			page.webflow({
					flow: 'plugin/arquetipos/modelosArquetipos/ARQSubirPrioridadArquetipo'
					,params: parametros
					,success : recargar 
				});
			}else{
				Ext.Msg.alert('<s:message code="plugin.arquetipos.modelo.consulta.subir" text="**Subir Prioridad" />','<s:message code="plugin.arquetipos.modelo.consulta.novalor" text="**Debe seleccionar un arquetipo de la lista" />');
			}
	</pfs:button>
	btSubir.iconCls = 'icon_subir';
	 
	<pfs:button name="btBajar" caption="**Bajar Prioridad" captioneKey="plugin.arquetipos.modelo.consulta.bajar" iconCls="icon_bajar">
		if (gridArquetiposModelo.getSelectionModel().getCount()>0){
    			var idArquetipoModelo = gridArquetiposModelo.getSelectionModel().getSelected().get('id'); 
                var parametros = {
                            idArquetipoModelo : idArquetipoModelo
				}
    			page.webflow({
					flow: 'plugin/arquetipos/modelosArquetipos/ARQBajarPrioridadArquetipo'
					,params: parametros
					,success : recargar
				});
			}else{
				Ext.Msg.alert('<s:message code="plugin.arquetipos.modelo.consulta.bajar" text="**Bajar Prioridad" />','<s:message code="plugin.arquetipos.modelo.consulta.novalor" text="**Debe seleccionar un arquetipo de la lista" />');
			}
	</pfs:button>
	
	<pfs:buttonedit name="btModificarArquetMod" 
			flow="plugin/arquetipos/modelosArquetipos/ARQEditarGridArquetiposModelo" 
			parameters="arquetipoParams" 
			windowTitle="${modelo.nombre}" 
			windowTitleKey=""
			store_ref="storeArquetipos"
			on_success="recargar"
			/>
	 
	
	
	<c:if test="${modelo.estado.codigo=='3'|| modelo.estado.codigo=='4'}">
		<pfs:grid name="gridArquetiposModelo"
			title="** Arquetipos asociados" 
			dataStore="storeArquetipos"  
			columnModel="columnasArquetipos" 
			collapsible="false" 
			titleKey="plugin.arquetipos.modelo.consulta.arquetipo"
			iconCls="icon_arquetipo"/>
	</c:if>
	
	<c:if test="${modelo.estado.codigo!='3'&& modelo.estado.codigo!='4'}">
		<pfs:grid name="gridArquetiposModelo"
			title="** Arquetipos asociados" 
			dataStore="storeArquetipos"  
			columnModel="columnasArquetipos" 
			collapsible="false" 
			titleKey="plugin.arquetipos.modelo.consulta.arquetipo"
			bbar="btAdd,btModificarArquetMod,btEliminar,btSubir,btBajar"
			iconCls="icon_arquetipo"/>
	</c:if>
		
		
	<pfs:button name="btCopia" caption="**Crear una copia"  captioneKey="plugin.arquetipos.modelo.consulta.copiar" iconCls="icon_copiar">
		Ext.Msg.show({
				title: '<s:message code="plugin.arquetipos.modelo.consulta.copiar" text="**Crear una copia" />'
				,msg: '<s:message code="plugin.arquetipos.modelo.consulta.seguroCopia" text="**¿Está seguro que desea crear una copia de este modelo?" arguments="${modelo.nombre}"/>'
				,buttons: Ext.Msg.YESNO
				,fn : function(bt,text){
					if (bt == 'yes'){
						page.webflow({
							flow: 'plugin/arquetipos/modelosArquetipos/ARQcopiaModelo'
							,params: arquetipoParams
							,success : Ext.Msg.alert('<s:message code="plugin.arquetipos.modelo.consulta.copiaCreada" text="**La copia del modelo ha sido creada correctamente" arguments="${modelo.nombre}"/>')
						});
					}
				}
			});
		
		
	</pfs:button>
	
	
	<pfs:button name="btSimula" caption="**Simular modelo"  captioneKey="plugin.arquetipos.modelo.consulta.simular" iconCls="icon_objetivos_pendientes">
		var w= app.openWindow({
					flow: 'plugin/arquetipos/modelosArquetipos/ARQsimulaModelo'
					,params: {id:'${modelo.id}'}
					,title : '<s:message code="plugin.arquetipos.modelo.consulta.simular" text="**Simular modelo" />'
					,closable : true
					,width: 700
					,success: recargar
					//,height: 600
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargar();
					});	
	</pfs:button>
	
	<pfs:button name="btLibera" caption="**Liberar modelo"  captioneKey="plugin.arquetipos.modelo.consulta.liberar" iconCls="icon_liberar">
			Ext.Msg.show({
				title: '<s:message code="plugin.arquetipos.modelo.consulta.liberar" text="**Liberar modelo" />'
				,msg: '<s:message code="plugin.arquetipos.modelo.consulta.seguroVigente" text="**¿Está seguro que desea marcar este modelo como vigente?" />'
				,buttons: Ext.Msg.YESNO
				,fn : function(bt,text){
					if (bt == 'yes'){
						page.webflow({
							flow: 'plugin/arquetipos/modelosArquetipos/ARQliberarModelo'
							,params: arquetipoParams
							,success : recargar
						});
					}
				}
			});
	</pfs:button>
	
	<c:if test="${modelo.estado.codigo!='2'}">
		<pfs:panel name="botonesPanel" columns="2" collapsible="false" >
			<pfs:items items="btCopia"/>
			<pfs:items items="btSimula"/>
		</pfs:panel>
	</c:if>	
	
	<c:if test="${modelo.estado.codigo=='2'}">
		<pfs:panel name="botonesPanel" columns="3" collapsible="false" >
			<pfs:items items="btCopia"/>
			<pfs:items items="btSimula"/>
			<pfs:items items="btLibera"/>
		</pfs:panel>
	</c:if>	
	 	
	var compuesto = new Ext.Panel({
	    items : [{items:[datosGeneralesPanel],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridArquetiposModelo],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[botonesPanel],border:false,style:'margin-top: 7px; margin-bottom:15px; margin-left:5px'}]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(compuesto);

</fwk:page>
