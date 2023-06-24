import { createSlice } from '@reduxjs/toolkit';

const initialState = {
    resultData: {},
    source: {},
};

const searchDataSlice = createSlice({
    name: 'searchData',
    initialState,
    reducers: {
        setStoreSearchData: (state, action) => {
            state.resultData = action.payload
        },
        setSearchSource: (state, action) => {
            state.source = action.payload
        }
    },
});

export const { setStoreSearchData,setSearchSource } = searchDataSlice.actions;
export default searchDataSlice.reducer;