import { createSlice } from '@reduxjs/toolkit';

const initialState = {
    resultData: {},
    searchLoading: {},
};

const searchDataSlice = createSlice({
    name: 'searchData',
    initialState,
    reducers: {
        setStoreSearchData: (state, action) => {
            state.resultData = action.payload
        },
        setSearchLoading: (state, action) => {
            state.resultData = action.payload
        }
    },
});

export const { setStoreSearchData,setSearchLoading } = searchDataSlice.actions;
export default searchDataSlice.reducer;