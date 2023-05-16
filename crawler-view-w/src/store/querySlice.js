import { createSlice } from '@reduxjs/toolkit';

const querySlice = createSlice({
  name: 'query',
  initialState: null,
  reducers: {
    setQueryData: (state, action) => {
      return action.payload;
    },
  },
});

export const { setQueryData } = querySlice.actions;
export default querySlice.reducer;
