import { createSlice } from '@reduxjs/toolkit';

const initialState = {
    chapters: {},
};

const chapterSlice = createSlice({
    name: 'chapters',
    initialState,
    reducers: {
        setStoreChapters: (state, action) => {
            state.chapters = action.payload
        },
    },
});

export const { setStoreChapters } = chapterSlice.actions;
export default chapterSlice.reducer;