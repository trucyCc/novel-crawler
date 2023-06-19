import { configureStore } from '@reduxjs/toolkit';
import SearchDataReducer from './SearchSlice'

const store = configureStore({
  reducer: {
    searchData: SearchDataReducer
  }
})

export default store;



