import ReactDOM from 'react-dom/client';

const API_BASE_URL = 'http://127.0.0.1:8989/';

export const RequestParamType = {
    JSON: 'application/json',
    XFORM: 'application/x-www-form-urlencoded'
}

export const RequestMethodType = {
    GET: 'GET',
    POST: 'POST'
}


export const fetchData = async (url, paramType, body, methodType) => {
    const response = await fetch(API_BASE_URL + url, {
        method: methodType,
        headers: {
            'Content-Type': paramType,
        },
        body: body
    }).catch(e => {
        console.log(e)
    });


    let json
    try {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        json = await response.json();
        if (json.code === undefined || json.code !== 200) {
            throw new Error(json.message);
        }

    } catch (error) {
        console.log(error)
    }

    return { response, json }

};

export const postXForm = async (url, body) => {
    return fetchData(url, RequestParamType.XFORM, body, RequestMethodType.POST);
}

export const postJson = async (url, body) => {
    return fetchData(url, RequestParamType.JSON, body, RequestMethodType.POST);
}

export const getXForm = async (url) => {
    return fetchData(url, RequestParamType.XFORM, undefined, RequestMethodType.GET);
}