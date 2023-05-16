import React, { useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useSelector } from 'react-redux';


const Search = () => {
    const [searchParams] = useSearchParams();
    const queryData = useSelector((state) => state.query);


    // 检查redux
    useEffect(() => {
        const searchValue = searchParams.get('search');
        console.log(searchValue);
        console.log(queryData);
    }, [])


    return (
        <div>
            <h1>Search</h1>
            <div></div>
        </div>
    );
};

export default Search;
