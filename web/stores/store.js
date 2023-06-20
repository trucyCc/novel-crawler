import { configureStore } from '@reduxjs/toolkit';
import SearchDataReducer from './SearchSlice'
import ChapterReducer from './ChapterSlice'

const store = configureStore({
  reducer: {
    searchData: SearchDataReducer,
    chapters: ChapterReducer
  }
})

export default store;



