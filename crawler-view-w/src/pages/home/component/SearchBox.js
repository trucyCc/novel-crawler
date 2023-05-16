import React, { useState } from 'react';
import { Button, CircularProgress, TextField } from '@mui/material';
import { debounce } from 'lodash';
import { styled } from '@mui/system';
import { query } from '../../../api/crawler';
import { useNavigate, createSearchParams } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import { setQueryData } from '../../../store/querySlice';

const SearchBox = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  height: '100vh',
});

const SearchWrapper = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  gap: '8px',
});

function SearchBar() {
  const [searchTerm, setSearchTerm] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();
  const queryData = useSelector((state) => state.query);
  const dispatch = useDispatch();


  const handleSearch = debounce(() => {
    setIsLoading(true);
    setTimeout(() => {
      query(searchTerm).then((data) => {
        setIsLoading(false);

        dispatch(setQueryData(data.json));

        navigate({
          pathname: "/search",
          search: createSearchParams({
            search: searchTerm,
          }).toString()
        });
      });

    }, 2000);
  }, 500);

  const handleInputChange = (event) => {
    setSearchTerm(event.target.value);
  };

  const handleButtonClick = () => {
    if (!isLoading) {
      handleSearch();
    }
  };

  const handleKeyPress = (event) => {
    if (event.key === 'Enter' && !isLoading) {
      handleSearch();
    }
  };

  return (
    <SearchBox>
      <SearchWrapper>
        <TextField
          variant="outlined"
          placeholder="Search"
          value={searchTerm}
          onChange={handleInputChange}
          onKeyPress={handleKeyPress}
          disabled={isLoading}
          sx={{ minWidth: '600px' }}
        />
        <Button
          variant="contained"
          onClick={handleButtonClick}
          disabled={isLoading}
          sx={{ minWidth: '100px' }}
        >
          {isLoading ? <CircularProgress size={24} /> : 'Search'}
        </Button>
      </SearchWrapper>
    </SearchBox>
  );
}

export default SearchBar;
