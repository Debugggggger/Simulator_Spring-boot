var cookiesMap = new Map();

function getGlobalValueLen() {
    return cookiesMap.length;
}

function clearAllGlobalValue(domain, path) {
    cookiesMap = new Map();
}

//setGlobalValue(변수이름, 변수값, 기간);
function setGlobalValue(name, value, exp) {
    cookiesMap.set(name, value);
}

// getGlobalValue(변수이름)
function getGlobalValue(name) {
    return cookiesMap.get(name);
}

// deleteGlobalValue(변수이름)
function deleteGlobalValue(name) {
    cookiesMap.delete(name)
}

function clearAllCookies(domain, path) {
    var doc = document,
        domain = domain || doc.domain,
        path = path || '/',
        cookies = doc.cookie.split(';'),
        now = +(new Date);
    for (var i = cookies.length - 1; i >= 0; i--) {
        doc.cookie = cookies[i].split('=')[0] + '=; expires=' + now + '; domain=' + domain + '; path=' + path;
    }
}

//setCookie(변수이름, 변수값, 기간);
function setCookie(name, value, exp) {
    var date = new Date();
    date.setTime(date.getTime() + exp * 24 * 60 * 60 * 1000);
    document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
};

// getCookie(변수이름)
// var is_expend = getCookie("expend");
function getCookie(name) {
    var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return value ? value[2] : null;
};

// deleteCookie(변수이름)
function deleteCookie(name) {
    document.cookie = name + '=; expires=Thu, 01 Jan 1999 00:00:10 GMT; path=/';
}