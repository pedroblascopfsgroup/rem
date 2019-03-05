/**
 *  Modelo para el tab Situación posesoria y llaves
 */
Ext.define('HreRem.model.ActivoSituacionPosesoria', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
        {
            name:'numActivo'
        },
        {
            name:'numActivoRem'
        },
        {
            name:'fechaRevisionEstado',
            type:'date',
            dateFormat: 'c'

        },
        {
            name:'ocupado'
        },
        {
            name:'accesoTapiado'
        },
        {
            name:'accesoAntiocupa'
        },
        {
            name:'conTitulo',
            convert: function(v, model){
                if(model.get('ocupado')=='0'){
                    return null;
                }else{
                    return v;
                }
            }
        },
        {
            name:'riesgoOcupacion'
        },
        {
            name:'fechaTitulo',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'fechaVencTitulo',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'fechaAccesoTapiado',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'fechaAccesoAntiocupa',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'rentaMensual'
        },
        {
            name:'fechaSolDesahucio',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'fechalanzamiento',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'fechaLanzamientoEfectivo',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'necesarias'
        },
        {
            name:'llaveHre'
        },
        {
            name:'fechaRecepcionLlave',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'numJuegos'
        },
         {
            name:'fechaTomaPosesion',
            type:'date',
            dateFormat: 'c'
        },
        {
            name: 'situacionJuridica'
        },
        {
            name:'indicaPosesion'
        },
        {
            name: 'tieneOkTecnico'
        },
        {
            name: 'tipoEstadoAlquiler'
        }
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',

		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoSituacionPosesoria',
            update: 'activo/saveActivoSituacionPosesoria',
            destroy: 'activo/getTabActivo'
        },

		extraParams: {tab: 'sitposesoriallaves'}
    }
});