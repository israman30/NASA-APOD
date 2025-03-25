# NASA-APOD

NASA APOD Viewer is a SwiftUI-based application that showcases NASA's Astronomy Picture of the Day (APOD). It allows users to view daily space images along with detailed descriptions, offering an educational and visually engaging experience.

- Daily Image Display: Automatically fetches and displays the Astronomy Picture of the Day (APOD) for the current date, including its title, date and explanation.
- Date Selection: Allows users to choose a specific date using a custom `DatePicker` to view the Astronomy Picture of the Day (APOD) from that date.
- Video Player: Displays embedded video content on days when a video is provided by the API.
- Empty Field Handling: Manages cases where the image endpoint parameters are empty or nil for certain days.
- Persistence data after fetched data from API using `UserDefaults` since this is a single object fetched at the time.
- Mininum deployment target: `iOS 16`
- Built on `SwiftUI`
- Architecture pattern `MVVM`
- Design `POP/DI` Protocol Oriented Programming and Depenency Injection.