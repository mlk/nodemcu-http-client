local espUnit = {}

function espUnit.runTests(testSet) 
    firstTest = nil
    
    for key,value in pairs(testSet) do
        local assertHelper = {}
        assertHelper.callback = false
        assertHelper.testFailed = false
        assertHelper.assertCalled = false
        assertHelper.testFailedMessage = ""
        assertHelper.key = key
        assertHelper.testToRun = value
        
        function assertHelper.areEqual(expected, actual) 
            assertHelper.assertCalled = true
            if expected ~= actual then
                if expected == nil then
                    expected = "<nil>"
                end
                if actual == nil then
                    actual = "<nil>"
                end
                assertHelper.testFailed = true;
                assertHelper.testFailedMessage  = assertHelper.testFailedMessage 
                    .."     expected \"" .. expected .. "\" actual \"" .. actual .. "\"\n" 
            end
        end

        function assertHelper.contains(expected, actual) 
            assertHelper.assertCalled = true
            if string.find(actual, expected) == nil then
                if expected == nil then
                    expected = "<nil>"
                end
                if actual == nil then
                    actual = "<nil>"
                end
                assertHelper.testFailed = true;
                assertHelper.testFailedMessage  = testHelpers[key].testFailedMessage 
                    .."     content \"" .. actual .. "\" did not contain \"" .. expected .. "\"\n" 
            end
        end

        function assertHelper.printResults() 
            if not assertHelper.assertCalled then
                print(assertHelper.key .. ": WARNING")
                print("No assert methods called")
            else 
                if assertHelper.testFailed then
                    print(assertHelper.key .. ": FAILED")
                    print(assertHelper.testFailedMessage)
                else
                    print(assertHelper.key .. ": PASSED")
                end
            end
            
            if assertHelper.nextTest ~= nil then
                assertHelper.nextTest.runTest()
            end
        end
        
        function assertHelper.runTest() 
            value(assertHelper)
            
            if not assertHelper.callback then
                assertHelper.printResults() 
            end
        end
        assertHelper.nextTest = firstTest
        firstTest = assertHelper
    end
    firstTest.runTest() 
end

return espUnit
