import React, { useEffect, useRef } from 'react'

export default function GoogleMapNavigation({ dest }) {
  const mapRef = useRef(null)
  const mapInstance = useRef(null)

  useEffect(() => {
    if (!window.google) {
      console.warn('Google Maps script not loaded')
      return
    }

    const defaultCenter = { lat: dest.lat || 37.7749, lng: dest.lng || -122.4194 }
    mapInstance.current = new window.google.maps.Map(mapRef.current, {
      center: defaultCenter,
      zoom: 13
    })

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((pos) => {
        const origin = { lat: pos.coords.latitude, lng: pos.coords.longitude }
        const directionsService = new window.google.maps.DirectionsService()
        const directionsRenderer = new window.google.maps.DirectionsRenderer()
        directionsRenderer.setMap(mapInstance.current)
        directionsService.route(
          {
            origin,
            destination: defaultCenter,
            travelMode: window.google.maps.TravelMode.DRIVING
          },
          (response, status) => {
            if (status === 'OK') {
              directionsRenderer.setDirections(response)
            } else {
              console.error('Directions request failed due to ' + status)
              // fallback: place markers
              new window.google.maps.Marker({ position: origin, map: mapInstance.current, label: 'You' })
              new window.google.maps.Marker({ position: defaultCenter, map: mapInstance.current, label: 'Dest' })
            }
          }
        )
      }, () => {
        // denied or unavailable - place markers only
        new window.google.maps.Marker({ position: defaultCenter, map: mapInstance.current, label: 'Dest' })
      })
    } else {
      new window.google.maps.Marker({ position: defaultCenter, map: mapInstance.current, label: 'Dest' })
    }
  }, [dest])

  return <div ref={mapRef} style={{ width: '100%', height: '100%' }} />
}