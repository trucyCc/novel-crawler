import { getXForm } from "../utils/request";

export const query = async (name) => {
    const formData = new URLSearchParams();
    formData.append('name', name);

    return getXForm(`crawler/query?${formData}` );
};