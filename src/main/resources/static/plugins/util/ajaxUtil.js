function ajaxEqSetting(method, eqName, request) {
    method = method.toUpperCase();
    var result;

    switch (method) {
        case "GET" :
            $.ajax({
                url: '/api/eqSetting/',
                type: 'GET',
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
        default:
            $.ajax({
                url: '/api/eqSetting/' + eqName,
                type: method,
                contentType: 'application/json; charset=utf-8',
                async: false,
                data: {
                    "request" : request
                },
                dataType: 'json',
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
    }

    return result;
}

function ajaxComponent(method, eqName, request) {
    method = method.toUpperCase();
    var result;

    switch (method) {
        case "GET" :
            $.ajax({
                url: '/api/component/' + eqName,
                type: 'GET',
                // contentType: 'application/json; charset=utf-8',
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
        default:
            $.ajax({
                url: '/api/component/' + eqName,
                type: method,
                contentType: 'application/json; charset=utf-8',
                async: false,
                data: {
                    "request" : request
                },
                dataType: 'json',
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
    }

    return result;
}

function ajaxMessageFrame(method, eqName, request) {
    method = method.toUpperCase();
    var result;

    switch (method) {
        case "GET" :
            $.ajax({
                url: '/api/messageFrame/' + eqName,
                type: 'GET',
                // contentType: 'application/json; charset=utf-8',
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
        default:
            $.ajax({
                url: '/api/messageFrame/' + eqName,
                type: method,
                contentType: 'application/json; charset=utf-8',
                async: false,
                data: {
                    "request" : request
                },
                dataType: 'json',
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
    }

    return result;
}

function ajaxScenario(method, eqName, request) {
    method = method.toUpperCase();
    var result;

    switch (method) {
        case "GET" :
            $.ajax({
                url: '/api/scenario/' + eqName,
                type: 'GET',
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
        default:
            $.ajax({
                url: '/api/scenario/' + eqName,
                type: method,
                contentType: 'application/json; charset=utf-8',
                async: false,
                data: {
                    "request" : request
                },
                dataType: 'json',
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
    }

    return result;
}

function ajaxEq(method, eqName, request) {
    method = method.toUpperCase();
    var result;

    switch (method) {
        case "GET" :
            $.ajax({
                url: '/api/eq/',
                type: 'GET',
                async: false,
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
        default:
            $.ajax({
                url: '/api/eq/' + eqName,
                type: method,
                contentType: 'application/json; charset=utf-8',
                async: false,
                data: {
                    "request" : request
                },
                dataType: 'json',
                success: function (data) {
                    result = data;
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    result = {
                        "code" : jqXHR.status,
                        "message" : "Bad",
                        "data" : jqXHR.responseText
                    };
                }
            });
            break;
    }

    return result;
}

function ajaxPorts() {
    var result;

    $.ajax({
        url: '/api/port',
        type: 'POST',
        async: false,
        success: function (data) {
            result = data;
        },
        error: function(jqXHR, textStatus, errorThrown) {
            result = {
                "code" : jqXHR.status,
                "message" : "Bad",
                "data" : jqXHR.responseText
            };
        }
    });

    return result;
}

function ajaxConvert(request, loopIndex) {
    var result;
    $.ajax({
        url: '/api/convert/' + loopIndex,
        type: 'POST',
        async: false,
        data: {
            "request" : request
        },
        dataType: 'json',
        success: function (data) {
            result = data;
        },
        error: function(jqXHR, textStatus, errorThrown) {
            result = {
                "code" : jqXHR.status,
                "message" : "Bad",
                "data" : jqXHR.responseText
            };
        }
    });

    return result;
}

function ajaxAllPorts() {
    var result;

    $.ajax({
        url: '/api/port/all',
        type: 'POST',
        async: false,
        success: function (data) {
            result = data;
        },
        error: function(jqXHR, textStatus, errorThrown) {
            result = {
                "code" : jqXHR.status,
                "message" : "Bad",
                "data" : jqXHR.responseText
            };
        }
    });

    return result;
}

function ajaxPath() {
    var result = null;

    $.ajax({
        url: '/api/sock/path',
        type: 'GET',
        async: false,
        success: function (data) {
            result = decodeURI(data);
            result = result.replace("%3A", ":")
            result = result.replace("%2F", "/")
        }
    });

    return result;
}

function ajaxFile(request, url) {
    var result = null;

    switch (url) {
        case "import":
            $.ajax({
                url: '/api/file/import',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: {
                    "request" : request
                },
                async: false,
                dataType: 'json',
                success: function (data) {
                    result = data;
                }
            });

            break;
        case "export":
            $.ajax({
                url: '/api/file/export',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: {
                    "request" : request
                },
                async: false,
                dataType: 'json',
                success: function (data) {
                    result = data;
                }
            });

            break;
        default : break;
    }
    return result;
}