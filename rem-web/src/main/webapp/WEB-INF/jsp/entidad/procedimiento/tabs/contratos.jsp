<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
    var limit = 25;

    var Contrato = Ext.data.Record.create([
        {name:'idContrato'}
        ,{name:'cc'}
        ,{name:'tipo'}
        ,{name:'diasIrregular'}
        ,{name:'saldoNoVencido'}
        ,{name:'saldoIrregular'}
        ,{name:'idPersona'}
        ,{name:'otrosint'}
        ,{name:'apellido1'}
        ,{name:'apellido2'} 
        ,{name:'tipointerv'}
        ,{name:'fechaExtraccion'}
        ,{name:'moneda'}
        ,{name:'fechaPosVendida'}
        ,{name:'saldoDudoso'}
        ,{name:'fechaDudoso'}
        ,{name:'estadoFinanciero'}
        ,{name:'fechaEstadoFinanciero'}
        ,{name:'estadoFinancieroAnt'}
        ,{name:'fechaEstadoFinancieroAnt'}
        ,{name:'provision'}
        ,{name:'estadoContrato'}
        ,{name:'fechaEstadoContrato'}
        ,{name:'movIntRemuneratorios'}
        ,{name:'movIntMoratorios'}
        ,{name:'comisiones'}
        ,{name:'gastos'}
        ,{name:'fechaCreacion'}
    ]);

    var contratoStore = page.getStore({
        eventName : 'listado'
        ,limit:limit
        ,storeId:'contratoProcedimientoStore'
        ,flow:'procedimientos/listadoContratosProcedimiento'
        ,reader: new Ext.data.JsonReader({
            root: 'contratos'
            ,totalProperty : 'total'
        }, Contrato)
    });
    
    entidad.cacheStore(contratoStore);

    var contratosRDCm= new Ext.grid.ColumnModel([
            {header: '<s:message code="contratos.cc" text="**Codigo" />', width: 120,  dataIndex: 'cc', id:'colCodigoContrato'},
            {header: '<s:message code="contratos.tipo" text="**Tipo" />', width: 120,  dataIndex: 'tipo'},
            {header: '<s:message code="contratos.saldoirr" text="**Saldo Irregular" />', width: 120, dataIndex: 'saldoIrregular',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.saldotot" text="**Saldo No Vencido" />', width: 120,  dataIndex: 'saldoNoVencido',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.diasirr" text="**Dias Irregular" />', width: 120,  dataIndex: 'diasIrregular'},
            {header: '<s:message code="contratos.otrosint" text="**Otros Intervinientes" />', width: 135,dataIndex: 'otrosint', id:'colIdPersona'},
            {header: '<s:message code="contratos.tipoint" text="**Tipo Intervencion" />', width: 135, dataIndex: 'tipointerv'},
            {header: '<s:message code="contratos.fExtraccion" text="**Fecha Extraccion" />', width: 135, dataIndex: 'fechaExtraccion', hidden:true},
            {header: '<s:message code="contratos.moneda" text="**Moneda Origen" />', width: 135, dataIndex: 'moneda', hidden:true},
            {header: '<s:message code="contratos.fPosVencida" text="**Fecha Pos Vencida" />', width: 135, dataIndex: 'fechaPosVendida', hidden:true},
            {header: '<s:message code="contratos.saldoDudoso" text="**Saldo Dudoso" />', width: 135, dataIndex: 'saldoDudoso', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.fDudoso" text="**Fecha Dudoso" />', width: 135, dataIndex: 'fechaDudoso', hidden:true},
            {header: '<s:message code="contratos.estFinanc" text="**Estado Financ" />', width: 135, dataIndex: 'estadoFinanciero'},
            {header: '<s:message code="contratos.estFinancAnt" text="**Estado Financ Ant" />', width: 135, dataIndex: 'estadoFinancieroAnt', hidden:true},
            {header: '<s:message code="contratos.fEstFinanc" text="**Fecha Estado Finan" />', width: 135, dataIndex: 'fechaEstadoFinanciero', hidden:true},
            {header: '<s:message code="contratos.fEstFinancAnt" text="**Fecha Estado Finan Ant" />', width: 135, dataIndex: 'fechaEstadoFinancieroAnt', hidden:true}, 
            {header: '<s:message code="contratos.provision" text="**Provision" />', width: 135, dataIndex: 'provision', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.estado" text="**Estado Contrato" />', width: 135, dataIndex: 'estadoContrato', hidden:true},
            {header: '<s:message code="contratos.fEstado" text="**Fecha Estado Contrato" />', width: 135, dataIndex: 'fechaEstadoContrato', hidden:true},
            {header: '<s:message code="contratos.intRemun" text="**Intereses Remuneratorios Ptes" />', width: 135, dataIndex: 'movIntRemuneratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.intMorat" text="**Intereses Moratorios Ptes" />', width: 135, dataIndex: 'movIntMoratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.comisiones" text="**Comisiones" />', width: 135, dataIndex: 'comisiones', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.gastos" text="**Gastos" />', width: 135, dataIndex: 'gastos', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.fCreacion" text="**Fecha Creacion" />', width: 135, dataIndex: 'fechaCreacion', hidden:true},
            {hidden:true, dataIndex: 'idPersona',fixed:true},
            {hidden:true, dataIndex: 'idContrato',fixed:true}
        ]
    );


        var contratosGrid=app.crearGrid(contratoStore,contratosRDCm,{
            title:'<s:message code="procedimiento.tabContratos.grid.titulo" text="**Contratos del procedimiento"/>'
            <app:test id="contratosGrid" addComa="true" />
            ,style : 'margin-bottom:10px;padding-right:10px'
            ,height : 400
            ,cls:'cursor_pointer'
            ,iconCls : 'icon_contratos_vencidos'
        });

    <c:if test="${!usuario.usuarioExterno}">
          var contratosGridListener = function(grid, rowIndex, e) {  
              var rec = grid.getStore().getAt(rowIndex);
  
              if(e.getTarget().className.indexOf('colCodigoContrato') != -1){
          //ABRO EL CONTRATO
          if (rec.get('idContrato')){
            var cc = rec.get('cc');
            var id = rec.get('idContrato');
            app.abreContrato(id, cc);
          }
        }
  
              if(e.getTarget().className.indexOf('colIdPersona') != -1){
                if(rec.get('idPersona')){
                    var nombre_cliente=rec.get('otrosint');
                    app.abreCliente(rec.get('idPersona'), nombre_cliente);
                }
        }
          };
          
          contratosGrid.addListener('rowdblclick', contratosGridListener);
    </c:if>
        
        //Panel propiamente dicho
        var panel =new Ext.Panel({
            title:'<s:message code="menu.clientes.consultacliente.contratosTab.title" text="**Contratos"/>'
            ,layout:'anchor'
            
            ,autoHeight:true
            ,bodyStyle : 'padding:10px'
            ,items:[
                contratosGrid
            ]
            ,nombreTab : 'contratosPanel'
        });


  panel.getValue = function(){
  }

  panel.setValue = function(){
  var data = entidad.get("data");
  entidad.cacheOrLoad(data, contratoStore, {idProcedimiento : data.id});
  }

        return panel;
})
